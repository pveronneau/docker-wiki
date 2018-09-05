#!/bin/bash
echo "Enter the desired SQL root password:"
read -s TYPED_PASS
export MYSQL_ROOT_PASSWORD=$TYPED_PASS
# Increase map count for elastic search
sysctl -w vm.max_map_count=262144
cat << EOF > /usr/lib/sysctl.d/70-elastic.conf 
vm.max_map_count=262144
EOF
# Build and start the containers
dnf install -y docker-compose
docker-compose build
docker-compose rm -f && docker-compose up -d