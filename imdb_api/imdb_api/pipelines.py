# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
from loguru import logger


TEXT_FIELDS = ("id", "title", "original_title", "genres",
               "synopsis", "poster_link", "audience")
INTEGER_FIELDS = ("duration_s", "release_year", "vote_count", "metacritic_score")


class ImdbApiPipeline:
    @logger.catch
    def process_item(self, item, spider):
        adapter = ItemAdapter(item)

        for field_name in INTEGER_FIELDS:
            value = adapter.get(field_name)
            try:
                adapter[field_name] = int(value)
            except TypeError:
                adapter[field_name] = None

        # Clean trailing spaces in textual fields
        for field_name in TEXT_FIELDS:
            value = adapter.get(field_name)
            try:
                adapter[field_name] = value.strip()
            except AttributeError:
                adapter[field_name] = None
        return item
