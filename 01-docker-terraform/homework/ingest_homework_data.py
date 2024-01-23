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
    table_name = params.table_name
    taxi_data_url = params.taxi_data_url
    zones_url = params.zones_url
    csv_name = 'output.csv'

    engine = create_engine(
        f'postgresql://{user}:{password}@{host}:{port}/{db}')

    os.system(f"wget {zones_url} -O zones.csv")
    df_zones = pd.read_csv("zones.csv")
    df_zones.to_sql(name='zones', con=engine, if_exists='replace')

    os.system(f"wget {taxi_data_url} -O {csv_name}.gz")
    os.system(f"gunzip {csv_name}.gz")
    df = pd.read_csv(csv_name)

    df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
    df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)

    # create schema
    df.head(n=0).to_sql(name=table_name,
                        con=engine, if_exists='replace')

    df.to_sql(name=table_name, con=engine, if_exists='append')


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Ingest data into PG db')
    parser.add_argument('--user', help="username for postgres")
    parser.add_argument('--password', help="password for postgres")
    parser.add_argument('--host', help="db host")
    parser.add_argument('--port', help="db port")
    parser.add_argument('--db', help="db name")
    parser.add_argument('--table_name', help='table to ingest data into')
    parser.add_argument('--taxi_data_url', help="url of taxi data csv")
    parser.add_argument('--zones_url', help="url for zones table")

    args = parser.parse_args()
    main(args)
