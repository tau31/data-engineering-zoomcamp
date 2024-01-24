#!/usr/bin/env python

from time import time
from sqlalchemy import create_engine
import pandas as pd
import argparse
import os


def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db

    con_url = f'postgresql://{user}:{password}@{host}:{port}/{db}'
    print(con_url)
    engine = create_engine(con_url)
    df = pd.read_sql_table("zones", engine)
    print(df)


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Ingest data into PG db')
    parser.add_argument('--user', help="username for postgres")
    parser.add_argument('--password', help="password for postgres")
    parser.add_argument('--host', help="db host")
    parser.add_argument('--port', help="db port")
    parser.add_argument('--db', help="db name")

    args = parser.parse_args()
    main(args)
