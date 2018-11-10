#!/bin/bash
#                         __
#                      _,'  `:--.__
#                    ,'    .       `'--._
#                  ,'    .               `-._
#          ,-'''--/    .                     `.
#        ,'      /   .    ,,-''`-._            `.
#       ; .     /   .   ,'         `,            |____
#       |      /   .   ;             :           |--._\
#       '     /   :    |      .      |           |
#        `.  ;   _     :             ;           |
#          `-:   `"     \           ,           _|==:--.__
#             \.-------._`.       ,`        _.-'     `-._ `'-._
#              \  :        `-...,-``-.    .'             `-.   | 
#               `.._         / | \     _.'                  `. | 
#                   `.._    '--'```  .'                       `|
#                       `.          /
#                .        `-.       \
#         ___   / \  __.--`/ , _,    \
#       ,',  `./,--`'---._/ = / \,    \  __
#      /    .-`           `"-/   \)_    "`
#    _.--`-<_         ,..._ /,-'` /    /
#  ,'.-.     `.    ,-'     `.    /`'.+(
# / /  /  __   . ,'    ,   `.  '    \ \ 
# |(_.'  /  \   ; |          |        ""_
# |     (   ;   `  \        /           `.
# '.     `-`   `    `.___,-`             `.
#   `.        `                           |
#    ; `-.__`                             |
#    \    -._                             |
#     `.                                  /
#      /`._                              /
#      \   `,                           /
#       `---'.     /                  ,'
#             '._,'-.              _,(_,_
#                    |`--.    ,,.-' `-.__)
#                     `--`._.'         `._)
#                                         `=-
# ____  ___ ____  _____   _____ _   _ _____   ____ ___ ____ _ 
#|  _ \|_ _|  _ \| ____| |_   _| | | | ____| |  _ \_ _/ ___| |
#| |_) || || | | |  _|     | | | |_| |  _|   | |_) | | |  _| |
#|  _ < | || |_| | |___    | | |  _  | |___  |  __/| | |_| |_|
#|_| \_\___|____/|_____|   |_| |_| |_|_____| |_|  |___\____(_)
#
# A script by Patrick Veronneau
#
# Version 1.0
#
#
# Side note: Nicole Matsui is a jerk for making me comment.
#
#### Companion script to setup a system cert using Letsencrypt and route 53

# Verify this is run by root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Enter your AWS access ID:"
read AWS_ACCESS_KEY_ID
echo "Enter your AWS Secret key:"
read AWS_SECRET_ACCESS_KEY

###
# Setup lets encrypt SSL cert
###
if [ ! -n "$AWS_ACCESS_KEY_ID" ] || [ ! -n "$AWS_SECRET_ACCESS_KEY" ]; then
    echo -e "\e[31mAbort, no AWS info entered\e[0m"
    exit 1
fi

# Install certbot with the route53 plugin
dnf install python3-certbot-dns-route53.noarch

if [ ! -f /root/.aws/config ]; then
mkdir -p /root/.aws
chmod 700 /root/.aws
touch /root/.aws/config
chmod 600 /root/.aws/config
cat > /root/.aws/config << EOF
[default]
aws_access_key_id=${AWS_ACCESS_KEY_ID}
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}

EOF
echo -e "\e[92mNew AWS configuration written\e[0m"
else
echo -e "\e[33mFound an existing aws config at /root/.aws/config delete this file if you wish to overwrite new values\e[0m"
fi

## Use certbot to create the certificate and deploy it
# Test if a cert is already setup
if [ ! -f /etc/letsencrypt/live/${HOSTNAME}/cert.pem ]; then
    echo -e "\e[34mRequesting certificate for $HOSTNAME\e[0m"
    certbot certonly --dns-route53 -d $HOSTNAME
else
    echo -e "\e[33mExisting certificate found, attempting renew\e[0m"
    certbot renew
fi
echo -e "\e[1mCertificate setup complete\e[0m"

if [ ! -f /etc/cron.d/certbot ]; then
# Add a crontab entry for auto renewal
echo -e "\e[1mAdding Crontab for auto renewal\e[0m"
echo "0 1 * * * root certbot renew" > /etc/cron.d/certbot
echo "0 12 * * * root certbot renew" >> /etc/cron.d/certbot
fi