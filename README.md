# docker-wiki
I created this as a proof of concept deployment of a php webapp segmented into different containers.  I have not tested it, so expect bugs.<br />
<br />
How to run the build.<br />
Run the setup_cert.sh script, or ensure the ssl certificates are properly referenced in the docker-compose.yml<br />
Run the install_wiki.sh script<br />
Run the media wiki installer by navigating to the web server on your docker host.<br />
During setup, ensure that the database setup is as follows:<br />
Hostname=mariadb<br />
database name=wikidb<br />
username=root<br />
password=whatever you set during the install_wiki.sh portion <br />
note: the passsword is taken from the MYSQL_ROOT_PASSWORD variable on your command line during execution of the docker-compose up<br />
Download the generated LocalSettings.php<br />
Add the following line to the end of the file:<br />
require_once "$IP/extra_settings.php";<br />
Un-comment the two lines under the volume section in docker-compose.yml and restart the stack (docker-compose down && docker-compose up -d)<br />
