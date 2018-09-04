#!/bin/bash
gunzip -k /restore/wiki.sql.gz
mysql -u root -pCHANGETHIS -e "CREATE DATABASE wikidb"
mysql -u root -pCHANGETHIS wikidb < /restore/wiki.sql
