# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class FilmItem(scrapy.Item):
    id = scrapy.Field()
    kind = scrapy.Field()
    title = scrapy.Field()
    original_title = scrapy.Field()
    genres = scrapy.Field()
    duration_s = scrapy.Field()
    release_year = scrapy.Field()
    end_year = scrapy.Field()
    synopsis = scrapy.Field()
    rating = scrapy.Field()
    vote_count = scrapy.Field()
    metacritic_score = scrapy.Field()
    poster_link = scrapy.Field()
    audience = scrapy.Field()
