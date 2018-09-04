#!/bin/bash
# Verify this is run by root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo "Enter the fqdn of the wiki (wiki.example.com):"
read WIKIFQDN
echo "Enter your AWS access ID:"
read AWS_ACCESS_KEY_ID
echo "Enter your AWS Secret key:"
read -s AWS_SECRET_ACCESS_KEY
# Install acme.sh and issue a certificate using AWS route 53
curl https://get.acme.sh | sh
/root/.acme.sh/acme.sh --issue --dns dns_aws -d $WIKIFQDN
# Increase map count for elastic search
sysctl -w vm.max_map_count=262144
cat << EOF > /usr/lib/sysctl.d/70-elastic.conf 
vm.max_map_count=262144
EOF
# Build and start the containers
dnf install -y docker-compose
docker-compose build --no-cache
docker-compose rm -f && docker-compose up -d