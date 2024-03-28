# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface

import sqlite3

from itemadapter import ItemAdapter
from loguru import logger


TEXT_FIELDS = ("id", "title", "original_title", "genres",
               "synopsis", "poster_link", "audience")
INTEGER_FIELDS = ("duration_s", "release_year", "vote_count", "metacritic_score")


class CleanApiPipeline:
    @logger.catch
    def process_item(self, item, spider):
        adapter = ItemAdapter(item)

        # Convert rating to float
        rating = adapter.get("rating")
        try:
            adapter["rating"] = float(rating)
        except TypeError:
            adapter["rating"] = None

        # Ensure conversion to integer for integer fields
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
    

class StoreSQLitePipeline:
    def __init__(self):
        self.con = sqlite3.connect("imdb.db")
        self.cur = self.con.cursor()
        self.create_table()

    @logger.catch
    def create_table(self):
        self.cur.execute("""
                         CREATE TABLE IF NOT EXISTS film_api(
                            id TEXT PRIMARY KEY ,
                            title TEXT,
                            original_title TEXT,
                            genres TEXT,
                            duration_s INTEGER,
                            release_year INTEGER,
                            rating REAL,
                            vote_count INTEGER,
                            metacritic_score INTEGER,
                            audience TEXT,
                            synopsis TEXT,
                            poster_link TEXT
                         )
                         """)
    

    @logger.catch
    def process_item(self, item, spider):
        adapter = ItemAdapter(item)
        self.cur.execute(
            """
            INSERT INTO film_api (
            id, title, original_title, genres, duration_s,
            release_year, rating, vote_count, metacritic_score,
            audience, synopsis, poster_link
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                adapter.get("id"),
                adapter.get("title"),
                adapter.get("original_title"),
                adapter.get("genres"),
                adapter.get("duration_s"),
                adapter.get("release_year"),
                adapter.get("rating"),
                adapter.get("vote_count"),
                adapter.get("metacritic_score"),
                adapter.get("audience"),
                adapter.get("synopsis"),
                adapter.get("poster_link")
            )
        )
        self.con.commit()
        return item
    

    @logger.catch
    def close_spider(self, spider):
        self.cur.close()
        self.con.close()   