import scrapy


class TargetSpider(scrapy.Spider):
    name = "target"
    allowed_domains = ["www.boxofficemojo.com"]
    start_urls = ["https://www.boxofficemojo.com/weekend/by-year/2024/?area=FR"]

    def parse(self, response):
        pass
