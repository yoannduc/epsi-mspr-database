FROM mariadb:12.0-rc

ARG MARIADB_USER
ENV MARIADB_USER=$MARIADB_USER

ARG MARIADB_PASSWORD
ENV MARIADB_PASSWORD=$MARIADB_PASSWORD

COPY ./migrations /docker-entrypoint-initdb.d

COPY ./migrations /tmp/tests

COPY ./pre-migrations.sh /tmp/pre-migrations.sh

RUN /tmp/pre-migrations.sh

EXPOSE 3306

CMD ["mariadbd"]
