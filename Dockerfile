FROM postgres  

ENV POSTGRES_USER=postgres  
ENV POSTGRES_PASSWORD=kvzoszhhzmP45?
ENV POSTGRES_DB=postgres

COPY init.sql /docker-entrypoint-initdb.d/
# docker build -t postgres ./
# docker run -d --name postgres_container -p 5432:5432 postgres 