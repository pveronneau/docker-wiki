#!/bin/sh
 
####################################################################
#                                                                  #
# Basic Backup Script for MediaWiki.                               #
# Created by Daniel Kinzler, brightbyte.de, 2008                   #
#                                                                  #
# This script may be freely used, copied, modified and distributed #
# under the sole condition that credits to the original author     #
# remain intact.                                                   #
#                                                                  #
# This script comes without any warranty, use it at your own risk. #
#                                                                  #
####################################################################
 
###############################################
# CHANGE THESE OPTIONS TO MATCH YOUR SYSTEM ! #
###############################################
 
wikidb="wikidb"                 # the database your wiki stores data in
#mysqlopt="-u username -ppassword"   # any options used for interacting with mysql
mysqlopt="-u root --password=$MYSQL_ROOT_PASSWORD"       # usually empty if username and password are provided in your .my.cnf
 
wikidir=/opt/mediawiki                    # the directory mediawiki is installed in
backupdir=/backup                      # the directory to write the backup to
 
##################
# END OF OPTIONS #
##################
 
timestamp=`date +%Y-%m-%d`

####################################
# Put the wiki into Read-only mode #
####################################
 
echo
echo "Putting the wiki in Read-only mode..."
 
maintmsg="\$wgReadOnly = 'Backup in Progress';"
 
grep "?>" "$wikidir"/LocalSettings.php > /dev/null
if [ $? -eq 0 ];
then
        sed -i "s/?>/$maintmsg?>/ig" "$wikidir"/LocalSettings.php
else
        echo "$maintmsg?>" >> "$wikidir"/LocalSettings.php
fi 
 
####################################
 
#dbdump="$backupdir/wiki-$timestamp.sql.gz"
#filedump="$backupdir/wiki-$timestamp.files.tgz"
#xmldump="$backupdir/wiki-$timestamp.xml.gz"
# Modified because I'm using logrotate for date
dbdump="$backupdir/wiki.sql.gz"
filedump="$backupdir/wiki.files.tgz"
xmldump="$backupdir/wiki.xml.gz"
 
 
echo
echo "Wiki backup:\n-------------"
echo " Database:  $wikidb\n Directory: $wikidir\n Backup to: $backupdir"
echo "\ncreating database dump \t$dbdump..."
mysqldump --default-character-set=latin1 $mysqlopt "$wikidb" | gzip > "$dbdump" || exit $?
 
echo "creating file archive \t$filedump..."
cd "$wikidir"
tar --exclude .svn -zhcf "$filedump" . || exit $?
 
echo "creating XML dump \t$xmldump..."
cd "$wikidir/maintenance"
php -d error_reporting=E_ERROR dumpBackup.php --full | gzip > "$xmldump" || exit $?
 
##########################################
# Put the wiki back into read/write mode #
##########################################
 
echo
echo "Bringing the wiki out of Read-only mode..."
 
sed -i "s/$maintmsg?>/?>/ig" "$wikidir"/LocalSettings.php
 
##########################################
 
echo
echo "Done!"
echo "Files to copy to a safe place:"
echo "$dbdump,"
echo "$filedump,"
echo "$xmldump"
 
#######
# END #
#######