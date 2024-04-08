import scrapy

class SortiesSpider(scrapy.Spider):
    name = "sorties"
    allowed_domains = ['senscritique.com']
    
    def start_requests(self):
        base_url = "https://www.senscritique.com/liste/1100_films_et_leur_budget/1584769?page={}&sortBy=DATE_RELEASE"
        for page_num in range(1, 41):  # Boucle sur les numéros de page de 1 à 40
            url = base_url.format(page_num)


            yield scrapy.Request(
                url=url,
                callback=self.parse,
                meta={"playwright": True}
            )

    def parse(self, response):
        films = response.xpath('//h3/a[@class="sc-e6f263fc-0 sc-4501ca2-1 cTitej hiOzhw sc-bd73f3c1-3 bwqoVT"]/text()').getall()
        budgets = response.xpath('//div[@class="sc-56c2a583-0 kVKNKg"]/p/span[@data-testid="linkify-text"]/text()').getall()

        for film, budget in zip(films, budgets):
            yield {
                "film": film.strip(),
                "budget": budget.strip()
            }





