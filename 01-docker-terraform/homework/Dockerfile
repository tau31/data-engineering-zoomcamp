FROM python:3.10

RUN apt install wget
RUN pip install pandas sqlalchemy psycopg2
WORKDIR /data_ingest
COPY ingest_homework_data.py ingest.py

ENTRYPOINT [ "python", "ingest.py"]
