# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
from loguru import logger
import mysql.connector

from .utils import convert_dates, convert_duration
import dot_env


LIST_FIELDS = ("casting", "director", "genres", "nationality")


class CleanPipeline:
    @logger.catch
    def process_item(self, item, spider):
        adapter = ItemAdapter(item)

        for field in LIST_FIELDS:
            # Join with '|' as a separator
            value = adapter.get(field)
            try:
                value = [item.strip() for item in value]
                adapter[field] = "|".join(value)
            except BaseException:
                adapter[field] = None

        # Release (convert it to format 'YYYY-MM-DD')
        release = adapter.get("release")
        if release is not None:
            adapter["release"] = convert_dates(release)
        else:
            adapter["release"] = None

        # Duration (convert to minutes)
        duration = adapter.get("duration")
        if duration is not None:
            adapter["duration"] = convert_duration(duration)
        else:
            adapter["duration"] = None
        
        # Budget (remove trailing spaces, but keep currency symbol)
        budget = adapter.get("budget")
        if budget is not None:
            if budget == '-':
                adapter["budget"] = None
            else:
                adapter["budget"] = budget.replace(" ", "")
        else:
            adapter["budget"] = None
   
        return item


class IncomingToMySQLPipeline:
    def __init__(self):
        # Connect to BDD
        print()
        print(">>>>>>>>>>>INIT INCOMING MOVIES<<<<<<<<<<<<<<<")
        self.conn = mysql.connector.connect(
            host = dot_env.FUNCTIONAL_HOST,
            user = dot_env.FUNCTIONAL_USER,
            password = dot_env.FUNCTIONAL_PASSWORD,
            database = dot_env.FUNCTIONAL_DATABASE,
            ssl_ca=dot_env.FUNCTIONAL_SSL
        )

        self.cur = self.conn.cursor()

    def process_item(self, item, spider):
        print()
        print(">>>>>>>>>>>INSERT INCOMING MOVIES<<<<<<<<<<<<<<<")
        try:
            id_allocine = item["film_id"]
            title = item["title"]
            img_src = item["img_src"]
            release_date = item["release"]
            duration = item["duration"]
            pivot_genres = item["genres"]
            synopsis = item["synopsis"]
            nationality = item["nationality"]
            distributor = item["distributor"]
            budget = item["budget"]
            pivot_director = item["director"]
            pivot_casting = item["casting"]
            copies = item["copies"]
            entries = item["entries"]

            request = f"""
            INSERT INTO movies_w0 (
                id_allocine, title, img_src, release_date, duration,
                pivot_genres, synopsis, nationality, distributor,
                budget, pivot_director, pivot_casting, copies, entries
                )
            VALUES ({id_allocine}, {title}, {img_src}, {release_date}, {duration},
                    {pivot_genres}, {synopsis}, {nationality}, {distributor},
                    {budget}, {pivot_director}, {pivot_casting}, {copies}, {entries})
            """
            self.cur.execute(request)
        except BaseException as e:
            print(e)
            print("request =", request)

        self.conn.commit()
        return item
    
    def close_spider(self, spider):
        self.cur.close()
        self.conn.close()
