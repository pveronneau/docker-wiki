#!/bin/sh
## Script to update a restored version of the wiki
# Update database to new version
cd /opt/mediawiki/maintenance && php update.php --skip-external-dependencies
# Rebuild Search index
sed -i 's/#$wgDisableSearchUpdate = true;/$wgDisableSearchUpdate = true;/' /opt/mediawiki/LocalSettings.php
php /opt/mediawiki/extensions/CirrusSearch/maintenance/updateSearchIndexConfig.php
sed -i 's/$wgDisableSearchUpdate = true;/#$wgDisableSearchUpdate = true;/' /opt/mediawiki/LocalSettings.php
php /opt/mediawiki/extensions/CirrusSearch/maintenance/forceSearchIndex.php --skipLinks --indexOnSkip && \
php /opt/mediawiki/extensions/CirrusSearch/maintenance/forceSearchIndex.php --skipParse