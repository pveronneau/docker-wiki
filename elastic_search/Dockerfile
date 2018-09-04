FROM docker.io/elasticsearch:5-alpine

VOLUME /usr/share/elasticsearch/data

ADD config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

EXPOSE 9200 9300
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]