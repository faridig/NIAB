import scrapy
from scrapy.loader import ItemLoader


class SortiesSpider(scrapy.Spider):
    name = "sorties"
    allowed_domains = ["www.senscritique.com"]
    start_urls = ["https://www.senscritique.com/films/sorties-cinema/2024"]

    def parse(self, response):
        films = response.xpath('//div[@class="sc-bd73f3c1-5 ezoJpD"]')



        for film in films:
            url = films.xpath('//h2/a/@href')
            

            yield scrapy.Request(
                url = self.start_urls[0] + url,
                callback =self.parse_details
            )

    def parse_details(self, response):
        main = response.xpath('(//div[@class="sc-72366723-0 lfYUbX"])[1]')



        pass
