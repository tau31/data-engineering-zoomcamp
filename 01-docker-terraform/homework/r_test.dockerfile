FROM r-base

RUN R -e 'install.packages("data.table")'
RUN R -e 'install.packages("DBI")'
RUN apt update
RUN apt-get install -y libpq-dev
RUN apt-get install -y libssl-dev 
RUN R -e 'install.packages("RPostgreSQL")'
ENTRYPOINT [ "R" ]