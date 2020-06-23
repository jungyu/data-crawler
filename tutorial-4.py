# tutorial-4
# 爬取 Google 焦點新聞

import time
from datetime import datetime
import configparser

import loguru
import sqlalchemy
import sqlalchemy.ext.automap
import sqlalchemy.orm
import sqlalchemy.schema

import urllib3
import requests
from bs4 import BeautifulSoup

def google(source_domain, crawler_url):
    target_url = crawler_url
    print('Start parsing google news....')
    rs = requests.session()
    res = rs.get(target_url, verify=False)
    soup = BeautifulSoup(res.text, 'html.parser')

    lists = []
    for news in soup.find_all(class_='NiLAwe'):
        try:
            title = news.find(class_='DY5T1d').text
            link = source_domain + '/' + news.find(class_='DY5T1d')['href']
            link.replace('./', '')
            lists.append({'title':title, 'link':link})
        except:
            print('.', end = '')

    return lists

def main():
    config = configparser.ConfigParser()
    config.read("config.ini")

    host = config['mysql']['Host']
    port = int(config['mysql']['Port'])
    username = config['mysql']['User']
    password = config['mysql']['Password']
    database = config['mysql']['Database']

    # 建立連線引擎
    engine = sqlalchemy.create_engine(
        f'mysql+pymysql://{username}:{password}@{host}:{port}/{database}'
    )
    # 取得資料庫元資料
    metadata = sqlalchemy.schema.MetaData(engine)
    # 產生自動對應參照
    automap = sqlalchemy.ext.automap.automap_base()
    automap.prepare(engine, reflect=True)
    # 準備 ORM 連線
    session = sqlalchemy.orm.Session(engine)

    # 載入 crawler_source 資料表資訊
    sqlalchemy.Table('crawler_source', metadata, autoload=True)
    # 取出對應 crawler_source 資料表的類別
    Source = automap.classes['crawler_source']

    try:
        loguru.logger.info('取出 Google 資料')
        source = session.query(Source).filter(
            Source.name == 'Google 焦點新聞'
        ).one()

        #爬取 Google 焦點新聞
        loguru.logger.info(f'{source.name}')
        lists = google(source.source_domain, source.crawler_url)

        # 寫入 crawler_list 資料表
        # 載入 crawler_source 資料表資訊
        sqlalchemy.Table('crawler_list', metadata, autoload=True)
        # 取出對應 crawler_source 資料表的類別
        Clist = automap.classes['crawler_list']
        for item in lists:
            created = int(time.mktime(datetime.now().timetuple()))
            # 反轉 timestamp 格式： now = datetime.fromtimestamp(timestamp)

            clist = Clist()
            clist.source_id = source.id
            clist.topic = source.name #TOFIX
            clist.article_title = item['title']
            clist.article_url = item['link']
            clist.created = created
            session.add(clist)

        # 寫入 crawler_list 資料表
        session.commit()

    except Exception as e:
        # 發生例外錯誤，還原交易
        session.rollback()
        loguru.logger.error('新增資料失敗')
        loguru.logger.error(e)
    
    finally:
        session.close()

if __name__ == '__main__':
    urllib3.disable_warnings()
    loguru.logger.add(
        f'{datetime.now().strftime("%Y%m%d%m%H%M%S")}.log',
        rotation='1 day',
        retention='7 days',
        level='DEBUG'
    )
    main()
