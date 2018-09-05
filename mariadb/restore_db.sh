#!/bin/bash
gunzip -k /restore/wiki.sql.gz
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE wikidb"
mysql -u root -p$MYSQL_ROOT_PASSWORD wikidb < /restore/wiki.sql
