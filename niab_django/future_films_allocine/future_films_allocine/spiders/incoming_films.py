from datetime import date, timedelta
import re

from loguru import logger
import scrapy

from future_films_allocine.items import FilmItem
from future_films_allocine.utils import convert_dates


BASE_URL = "https://www.allocine.fr"

# Logger Setup
logs_path = 'logs/incoming_logfile.log'
logger.add(logs_path, level="ERROR")


class IncomingFilmsSpider(scrapy.Spider):
    name = "incoming_films"

    custom_settings = {
        'ITEM_PIPELINES': {
            "future_films_allocine.pipelines.CleanPipeline": 100,
            "future_films_allocine.pipelines.IncomingToMySQLPipeline": 200}
    }

    @logger.catch
    def start_requests(self):
        # Getting the release date page (corresponding to next wednesday)
        today = date.today()
        days_until_wednesday = (2 - today.weekday() + 7) % 7
        if days_until_wednesday == 0:
            days_until_wednesday = 7
        next_wednesday = today + timedelta(days=days_until_wednesday)
        next_wed_str = next_wednesday.strftime("%Y-%m-%d")

        releases_url = f"{BASE_URL}/film/agenda/sem-{next_wed_str}"

        yield scrapy.Request(url = releases_url,
                             callback = self.parse_releases_page,
                             meta = {"next_wed_str": next_wed_str})
    
    @logger.catch
    def parse_releases_page(self, response):
        if response.status != 200:
            logger.error(f"Non 200 Status Code: {response.status_code} for URL {response.url}")
        next_wed_str = response.meta["next_wed_str"]
        # Retrieve incoming films URLs
        url_suffixes = response.css("a.meta-title-link::attr(href)").getall()

        for suffix in url_suffixes:
            film_url = BASE_URL + suffix

            yield scrapy.Request(url = film_url,
                                 callback = self.parse_film_page,
                                 meta = {"next_wed_str": next_wed_str})

    @logger.catch
    def parse_film_page(self, response):
        if response.status != 200:
            logger.error(f"Non 200 Status Code: {response.status_code} for URL {response.url}")
        next_wed_str = response.meta["next_wed_str"]
        film_info = response.xpath('//div[@class="meta-body-item meta-body-info"]')
        # Filter films not released in theatres
        display = film_info.css("span.meta-release-type::text").get().strip()
        if display == "en salle":
            # Filter concerts, festivals and opera
            film_info = film_info.xpath('.//span/text()').getall()
            release_date_ac = film_info.pop(0).strip()
            film_info = set(film_info)
            # We continue only if the sets' intersection is the empty set
            if not(film_info & {"Concert", "Divers", "Opéra"}):
                # Finally, filter films not released on wednesday
                # First, let's check if there's a relaunch_date
                relaunch_date_ac = response.xpath('//div[@class="meta-body-item"]/span[contains(@class, "date")]/text()').get()
                try:
                    relaunch_date = convert_dates(relaunch_date_ac.strip())                    
                except BaseException:
                    relaunch_date = None
                release_date = convert_dates(release_date_ac)
                if next_wed_str in {relaunch_date, release_date}:
                    # WE CAN NOW PROCESS DATA
                    item = FilmItem()
                    item["film_id"] = int(re.search(r"\d+", response.url).group())
                    item["title"] = response.css("div.titlebar-title::text").get()
                    item["img_src"] = response.css("[title^='Bande-'] > img::attr(src)").get()
                    if relaunch_date_ac:
                        item["release"] = relaunch_date_ac
                    else:
                        item["release"] = release_date_ac
                    # Duration & Genres
                    raw_info = response.css('div.meta-body-info ::text').getall()
                    info = [item.strip() for item in raw_info
                            if item not in ('\nen salle\n', '|', '\n', ',\n')]
                    try:
                        item["duration"] = info[1]
                    except IndexError:
                        item["duration"] = None
                    item["genres"] = info[2:]  # A slice never raises an exception

                    item["synopsis"] = response.css("section#synopsis-details div.content-txt p::text").get()
                    item["nationality"] = response.css("span.nationality::text").getall()
                    # Distributor
                    prev_sel = response.xpath('//span[@class="what light" and contains(text(), "Distributeur")]')
                    item["distributor"] = prev_sel.xpath('following-sibling::node()[2]/text()').get().strip()
                    # Budget
                    budget_span = response.xpath("//span[contains(text(), 'Budget')]")
                    item["budget"] = budget_span.xpath('.//following-sibling::node()/text()').get()
                    # Copies
                    raw_copies = response.xpath('//span[@class="txt" and contains(text(), "Séances")]/text()').get()
                    try:
                        copies = int(re.search(r"\d+", raw_copies).group())
                        item["copies"] = copies
                    except BaseException:
                        item["copies"] = None

                    # Follow the casting page
                    casting_page_url = f"https://www.allocine.fr/film/fichefilm-{item['film_id']}/casting/"

                    yield scrapy.Request(url = casting_page_url,
                                        callback = self.parse_casting_page,
                                        meta = {"item": item})
    
    @logger.catch              
    def parse_casting_page(self, response):
        if response.status != 200:
            logger.error(f"Non 200 Status Code: {response.status_code} for URL {response.url}")
        item = response.meta["item"]
        item["director"] = response.css('section.casting-director a::text').getall()
        item["casting"] = response.css('section.casting-actor *.meta-title-link::text').getall()

        # Don't forget the prediction field! ;)
        item["pred_entries"] = None
        
        yield item
