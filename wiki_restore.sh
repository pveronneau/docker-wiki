#!/bin/bash
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
export WIKI_BACKUP="$PWD/restore/"
export WIKI_FILES=`ls -1t $WIKI_BACKUP/wiki.files.* | head -1`
export WIKI_DB=`ls -1t $WIKI_BACKUP/wiki.sql.* | head -1`
echo "Warning! Restore takes a long time, let the script complete."
#Deployment Script for a new system
# Increase map count for elastic search
sysctl -w vm.max_map_count=262144
cat << EOF > /usr/lib/sysctl.d/70-elastic.conf 
vm.max_map_count=262144
EOF
# Build and start the containers
dnf install -y docker-compose
docker-compose pull || docker-compose build
docker-compose rm -f && docker-compose up -d
# Restore the database
cp $WIKI_DB /var/lib/docker/volumes/backup-volume/_data/wiki.sql.gz
docker exec -it mariadb /restore_db.sh
## Extract binary files
tar --strip-components=2 -C /var/lib/docker/volumes/images-volume/_data/ -xvf $WIKI_FILES ./images/*
# Update the wiki and seed elastic search
docker exec -it mediawiki /update.sh
# Set emergency IP - used for emergency re-location
#export IP_ADDRESS=`hostname -I | awk '{print $1}'`
#docker exec -it mediawiki /emergency_name.sh $IP_ADDRESS
