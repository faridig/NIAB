import scrapy


class IncomingFilmsSpider(scrapy.Spider):
    name = "incoming_films"
    allowed_domains = ["site.com"]
    start_urls = ["https://site.com"]

    def parse(self, response):
        pass
