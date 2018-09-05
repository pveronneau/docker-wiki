FROM php:7-fpm-alpine
## Set Version
ENV MEDIAWIKI 1_31
# Add base packages
RUN apk update && apk add --no-cache curl imagemagick diffutils git zip openssl ffmpeg ghostscript poppler-utils

## Set PHP variables
COPY config/php-wiki.ini /usr/local/etc/php/conf.d/php-wiki.ini

## Add php extensions
# Install necessary dev packages
RUN apk update && apk add --no-cache bzip2-dev curl-dev icu-dev ldb-dev libxml2-dev libpng-dev pcre-dev libjpeg-turbo-dev freetype-dev
# Install and compile php extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
docker-php-ext-install bz2 ctype curl dom gd hash iconv intl json mbstring mysqli opcache session sockets xml zip

## Install Mediawiki
RUN mkdir /opt && cd /opt/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/core.git && mv /opt/core /opt/mediawiki
# Install Skins
RUN cd /opt/mediawiki/skins/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/skins/CologneBlue
RUN cd /opt/mediawiki/skins/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/skins/Modern
RUN cd /opt/mediawiki/skins/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/skins/MonoBook
RUN cd /opt/mediawiki/skins/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/skins/Vector
# Install default plugins
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Cite
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/CiteThisPage
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/ConfirmEdit
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Gadgets
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/ImageMap
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/InputBox
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Interwiki
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/LocalisationUpdate
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Nuke
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/ParserFunctions
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/PdfHandler
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Poem
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Renameuser
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/SpamBlacklist
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/SyntaxHighlight_GeSHi
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/TitleBlacklist
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/WikiEditor
# Additional Mediawiki Extensions
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/mediawiki/extensions/CategoryTree.git
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/CirrusSearch.git
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/Elastica
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/mediawiki/extensions/MsUpload
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/MwEmbedSupport.git
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/OpenIDConnect
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} http://phabricator.wikimedia.org/diffusion/EPFM/extension-pageforms.git
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/PluggableAuth
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/mediawiki/extensions/ReplaceText.git 
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/p/mediawiki/extensions/SemanticDrilldown
RUN cd /opt/mediawiki/extensions/ && git clone -b REL${MEDIAWIKI} https://gerrit.wikimedia.org/r/mediawiki/extensions/TimedMediaHandler.git 

# Update submodules (skins, base extensions)
RUN cd /opt/mediawiki/ && git pull && git submodule update --init --recursive
# Install Composer and install composer based Mediawiki extensions
ADD config/composer_install.sh /opt/mediawiki/
RUN cd /opt/mediawiki && /opt/mediawiki/composer_install.sh && \
php composer.phar update && \
php composer.phar install
RUN cd /opt/mediawiki && php composer.phar require mediawiki/semantic-media-wiki
RUN cd /opt/mediawiki && php composer.phar require "mediawiki/chameleon-skin"
RUN cd /opt/mediawiki && php composer.phar require "mediawiki/page-forms"
RUN cd /opt/mediawiki && php composer.phar require "jumbojett/openid-connect-php"

# Fix missing extensions
RUN cd /opt/mediawiki/extensions/Elastica/ && php /opt/mediawiki/composer.phar install --no-dev
RUN cd /opt/mediawiki/extensions/SyntaxHighlight_GeSHi && /opt/mediawiki/composer.phar install

## Add Custom Files
## If you have a custom LocalSettings.php file
#COPY config/LocalSettings.php /opt/mediawiki/LocalSettings.php
COPY config/logo.jpg /opt/mediawiki/resources/assets/logo.jpg
COPY config/favicon.ico /opt/mediawiki/favicon.ico
COPY config/chameleon_layout.xml /opt/mediawiki/skins/chameleon/layouts/custom.xml
COPY config/backup.sh /usr/bin/wiki-backup.sh
COPY config/update.sh /update.sh

## Run update and enable semantic mediawiki (only required for update)
#RUN cd /opt/mediawiki/ && php maintenance/update.php --quick --skip-external-dependencies 

VOLUME /opt/mediawiki/
ENV MYSQL_ROOT_PASSWORD null
EXPOSE 9000
CMD ["/usr/local/sbin/php-fpm", "-Rc", "/usr/local/etc/php-fpm.conf"]