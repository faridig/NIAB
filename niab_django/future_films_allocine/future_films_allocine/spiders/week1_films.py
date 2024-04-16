from loguru import logger
import mysql.connector
import scrapy

from future_films_allocine import dot_env
from future_films_allocine.items import Week1Item


BASE_URL = "https://www.allocine.fr/film/fichefilm-"


# Logger Setup
logs_path = 'logs/week1_logfile.log'
logger.add(logs_path, level="ERROR")

class Week1FilmsSpider(scrapy.Spider):
    name = "week1_films"

    custom_settings = {
        'ITEM_PIPELINES': {"future_films_allocine.pipelines.Week1ToMySQLPipeline": 100}
    }

    @logger.catch
    def start_requests(self):
        conn = mysql.connector.connect(
                host = dot_env.FUNCTIONAL_HOST,
                user = dot_env.FUNCTIONAL_USER,
                password = dot_env.FUNCTIONAL_PASSWORD,
                database = dot_env.FUNCTIONAL_DATABASE,
                ssl_ca=dot_env.FUNCTIONAL_SSL
            )
        cur = conn.cursor()

        request = """
        SELECT id_allocine
          FROM movies_w1
        """
        cur.execute(request)
        film_ids = cur.fetchall()

        for film_id in film_ids:
            item = Week1Item()
            item["film_id"] = film_id[0]
            film_box_office_url = f"{BASE_URL}{film_id[0]}/box-office/"
            yield scrapy.Request(url = film_box_office_url,
                                callback = self.parse_film_box_office_page,
                                meta = {"item": item})
            

    def parse_film_box_office_page(self, response):
        if response.status != 200:
            logger.error(f"Non 200 Status Code: {response.status_code} for URL {response.url}")
        item = response.meta["item"]

        try:
            # Get text, clean trailing spaces, tabs and carriage return
            true_entries = response.css('td[data-heading="Entrées"]::text').get().strip()
            # Clean space as 3 digits' separator, then transtype to int
            item["true_entries"] = int(true_entries.replace(" ", ""))
        except BaseException:
            item["true_entries"] = 'NULL'

        yield item
