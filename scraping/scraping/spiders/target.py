import scrapy
from loguru import logger
from scrapy.spiders import CrawlSpider
from scrapy_selenium import SeleniumRequest
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class TargetSpider(CrawlSpider):
    name = "target"
    allowed_domains = ["www.boxofficemojo.com"]
    URLs = [f"https://www.boxofficemojo.com/weekend/by-year/{year}/?area=FR" for year in range(2021, 2025)]
    
    def start_requests(self):
        #URLs = [f"https://www.boxofficemojo.com/weekend/by-year/{year}/?area=FR" for year in range(2021, 2025)]
        for url in self.URLs:
            yield SeleniumRequest(url=url, callback=self.parse)
        
        # POUR TESTER SUR UNE SEULE PAGE
        # yield SeleniumRequest(url='https://www.boxofficemojo.com/weekend/by-year/2024/?area=FR', callback=self.parse)

    @logger.catch
    def activate_ChromeDriver(self, response):
        
        # Define Options for ChromeDriver
        chrome_options = Options()
            # 1. Execute Chrome in headless mode (without graphic interface)
        chrome_options.add_argument("--headless")
            # 2. Desable GPU
        chrome_options.add_argument("--disable-gpu")
        
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
            yield {
                'year' : ''.join(filter(str.isdigit, response.url)),
                'url': response.url,
                'weekend': link.get_attribute('href')
            }
