from datetime import datetime
import json
import urllib.parse

from loguru import logger
import scrapy

from imdb_api.items import FilmItem


API_HEADERS = {
        'Accept': 'application/graphql+json, application/json',
        'Content-Type': 'application/json',
}

class ApiSpider(scrapy.Spider):
    name = "apispider"
    allowed_domains = ["caching.graphql.imdb.com"]
    start_urls = ["https://caching.graphql.imdb.com/"]

    def __init__(self, start: str, *args, **kwargs):
        super(ApiSpider, self).__init__(*args, **kwargs)
        """
        `start` is the starting date for films, in format YYYY-MM-DD
        """
        self.start = start

    @logger.catch
    def start_requests(self):
        # There's no `after` parameter for this initial call
        variables = {
            "first": 1_000,  # Number of films you want to get info with one call
            "locale": "en-US",
            "releaseDateConstraint": {
                "releaseDateRange": {
                    "start": self.start,
                    "end": datetime.now().strftime("%Y-%m-%d")
                }
            },
            "sortBy": "POPULARITY",
            "sortOrder": "ASC",
            "titleTypeConstraint": {
                "anyTitleTypeIds": ["movie"]
            }
        }

        extensions = {
            "persistedQuery": {
                "sha256Hash": "65dd1bac6fea9c75c87e2c0435402c1296b5cc5dd908eb897269aaa31fff44b1",
                "version": 1
            }
        }

        # URL-encode the variables and extensions as before
        variables_encoded = urllib.parse.quote(json.dumps(variables))
        extensions_encoded = urllib.parse.quote(json.dumps(extensions))

        # Construct the full API URL
        url = f"{self.start_urls[0]}?operationName=AdvancedTitleSearch&variables={variables_encoded}&extensions={extensions_encoded}"             

        yield scrapy.Request(url, headers=API_HEADERS, callback=self.parse)


    @logger.catch
    def parse(self, response):
        json_resp = response.json()
        data = json_resp['data']['advancedTitleSearch']

        # 1 - Extract film data
        items = data["edges"]
        for item in items:
            film = item["node"]["title"]

            ## Implement hard logic for complex keys

            # title
            if (title_text := film.get('titleText', {})) is not None:
                title = title_text.get('text')
            else:
                title = None
                
            # original_title
            if (original_title_text := film.get('originalTitleText', {})) is not None:
                original_title = original_title_text.get('text')
            else:
                original_title = None
                
            # Special case of 'genres'
            genres = film.get('titleGenres', {}).get('genres', [])
            genres = ','.join([genre.get('genre', {}).get('text', '') for genre in genres])

            # duration_s
            if (runtime := film.get('runtime', {})) is not None:
                duration_s = runtime.get('seconds')
            else:
                duration_s = None

            # release_year & end_year
            if (release := film.get('releaseYear', {})) is not None:
                release_year = release.get('year')
            else:
                release_year = None

            # synopsis
            if (plot := film.get('plot', {})) is None:
                synopsis = None
            else:
                if (plot_text := plot.get('plotText', {})) is None:
                    synopsis = None
                else:
                    synopsis = plot_text.get('plainText')
            
            # rating & vote_count
            if (ratings_summary := film.get('ratingsSummary', {})) is not None:
                rating = ratings_summary.get('aggregateRating')
                vote_count = ratings_summary.get('voteCount')
            else:
                rating = vote_count = None
                
            # metacritic_score
            if (metacritic := film.get('metacritic', {})) is None:
                metacritic_score = None
            else:
                if (metascore := metacritic.get('metascore', {})) is None:
                    metacritic_score = None
                else:
                    metacritic_score = metascore.get('score')
            
            # poster_link
            if (primary_image := film.get('primaryImage', {})) is not None:
                poster_link = primary_image.get('url')
            else:
                poster_link = None

            # audience
            if (certificate := film.get('certificate', {})) is not None:
                audience = certificate.get('rating')
            else:
                audience = None

            # Output a film item
            film_item = FilmItem()

            film_item["id"] = film.get("id", "missing")
            film_item["title"] = title
            film_item["original_title"] = original_title
            film_item["genres"] = genres
            film_item["duration_s"] = duration_s
            film_item["release_year"] = release_year
            film_item["synopsis"] = synopsis
            film_item["rating"] = rating
            film_item["vote_count"] = vote_count
            film_item["metacritic_score"] = metacritic_score
            film_item["poster_link"] = poster_link
            film_item["audience"] = audience

            yield film_item

        # 2 - Schedule next API call
        has_next_page = data.get('pageInfo', {}).get('hasNextPage', False)  
        if has_next_page:
            # WARNING: Setting endCursor to '' may cause problems.
            end_cursor = data.get('pageInfo', {}).get('endCursor', '')
            yield from self.schedule_next_api_call(end_cursor)


    @logger.catch
    def schedule_next_api_call(self, end_cursor):
        # Forge the next API request URL using the cursor
        variables = {
            # Keeping the same parameters as in start_requests
            "first": 1_000,  # Number of items you want
            "locale": "en-US",
            "releaseDateConstraint": {
                "releaseDateRange": {
                    "start": self.start,
                    "end": datetime.now().strftime("%Y-%m-%d")
                }
            },
            "sortBy": "POPULARITY",
            "sortOrder": "ASC",
            "titleTypeConstraint": {
                "anyTitleTypeIds": self.kind
            },
            # Adding end_cursor to delimit request
            "after": end_cursor,
        }
        extensions = {
        "persistedQuery": {
            "sha256Hash": "65dd1bac6fea9c75c87e2c0435402c1296b5cc5dd908eb897269aaa31fff44b1",
            "version": 1
        }
        }
        # URL-encode the variables and extensions as before
        variables_encoded = urllib.parse.quote(json.dumps(variables))
        extensions_encoded = urllib.parse.quote(json.dumps(extensions))

        # Construct the full URL as before
        next_api_url = f"{self.start_urls[0]}?operationName=AdvancedTitleSearch&variables={variables_encoded}&extensions={extensions_encoded}"

        yield scrapy.Request(next_api_url, headers=API_HEADERS, callback=self.parse)
