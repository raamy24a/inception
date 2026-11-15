FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/* /var/lib/mysql/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld_safe"]
