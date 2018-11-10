# docker-wiki
I created this as a proof of concept deployment of a php webapp segmented into different containers.  I have not tested it, so expect bugs.  

## How to run the build.
Run the `setup_cert.sh` script, or ensure the ssl certificates are properly referenced in the docker-compose.yml  
Run the `install_wiki.sh` script  
Run the media wiki installer by navigating to the web server on your docker host.  
During setup, ensure that the database setup is as follows:  

`Hostname=mariadb`  
`database name=wikidb`  
`username=root`  
`password=whatever you set during the install_wiki.sh portion`  

note: the passsword is taken from the MYSQL_ROOT_PASSWORD variable on your command line during execution of the `docker-compose up`  

Download the generated `LocalSettings.php`  

Add the following line to the end of the file:  

`require_once "$IP/extra_settings.php";`  

Un-comment the two lines under the volume section in docker-compose.yml and restart the stack `docker-compose down && docker-compose up -d`
