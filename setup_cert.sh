#!/bin/bash
# Setup the lets encrypt certs using route 53, do this manually if you do not use route 53
# Verify this is run by root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo "Enter your AWS access ID:"
read AWS_ACCESS_KEY_ID
echo "Enter your AWS Secret key:"
read -s AWS_SECRET_ACCESS_KEY
# Install acme.sh and issue a certificate using AWS route 53
curl https://get.acme.sh | sh
/root/.acme.sh/acme.sh --issue --dns dns_aws -d $HOSTNAME