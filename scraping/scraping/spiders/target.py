import scrapy
from loguru import logger
from scrapy.spiders import CrawlSpider
from scrapy_selenium import SeleniumRequest
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By

class TargetSpider(CrawlSpider):
    
    name = "target"
    allowed_domains = ["www.boxofficemojo.com"]
    URLs = [f"https://www.boxofficemojo.com/weekend/by-year/{year}/?area=FR" for year in range(2021, 2025)]
    
    
    def start_requests(self):
        # Loop to get every URL sent to next function
        for url in self.URLs:
            yield SeleniumRequest(url=url, callback=self.parse)
        
        # Just to test if everything works on one page only
        # yield SeleniumRequest(url='https://www.boxofficemojo.com/weekend/by-year/2024/?area=FR', callback=self.parse)


    @logger.catch
    def activate_ChromeDriver(self, response):
        
        # Define Options for ChromeDriver
        chrome_options = Options()
        # Execute Chrome in headless mode (without graphic interface)
        chrome_options.add_argument("--headless")
        
        # Activate ChromeDriver
        driver = webdriver.Chrome(options=chrome_options)
        
        # Load Url to ChromeDriver
        driver.get(response.url)
        
        return driver


    @logger.catch
    def parse(self, response):
        
        driver = self.activate_ChromeDriver(response)
        
        weekend_links = driver.find_elements(By.CSS_SELECTOR, 'td.mojo-field-type-date_interval a')
        for link in weekend_links:
            data = {
                'year' : ''.join(filter(str.isdigit, response.url)),
                'url': response.url,
                'weekend': link.get_attribute('href')
            }
            yield SeleniumRequest(url=link.get_attribute('href'), callback=self.parse_weekend_page, meta={'link_data': data})


    @logger.catch
    def parse_weekend_page(self, response):
        
        link_data = response.meta.get('link_data')
        
        driver = self.activate_ChromeDriver(response)
        
        titles = []
        movie_titles = driver.find_elements(By.CSS_SELECTOR, 'tr.mojo-annotation-isNewThisWeek td.mojo-field-type-release a')
        for title in movie_titles:
            titles.append(title.text)
            
        urls = []
        movie_urls = driver.find_elements(By.CSS_SELECTOR, 'tr.mojo-annotation-isNewThisWeek td.mojo-field-type-release a')
        for url in movie_urls:
            url = urls.append(url.get_attribute('href'))
        
        # for 1st week
        total_grosses = []
        ttl_grsss = driver.find_elements(By.CSS_SELECTOR, 'tr.mojo-annotation-isNewThisWeek td.mojo-field-type-money')
        for gross in ttl_grsss:
            total_grosses.append(gross.text)
            
        distributors = []
        companies = driver.find_elements(By.CSS_SELECTOR, 'tr.mojo-annotation-isNewThisWeek td.mojo-field-type-release_studios a')
        for distrib in companies:
            distributors.append(distrib.text)
        
        yield {
            'year': link_data['year'],
            # 'url': link_data['url'],
            'weekend': link_data['weekend'],
            'movie_titles': titles,
            'movie_urls': urls,
            'movie_grosses' : total_grosses,
            'movie_distributors' : distributors,
        }