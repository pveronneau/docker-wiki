FROM docker.io/mariadb

VOLUME /var/lib/mysql
COPY restore_db.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
ENV MYSQL_ROOT_PASSWORD null
EXPOSE 3306
CMD ["mysqld"]
