<?php
# Add these variables to a generated LocalSettings.php
# Extra Extensions
require_once "$IP/extensions/Bootstrap/Bootstrap.php";
wfLoadExtension( 'CategoryTree' );
require_once "$IP/extensions/CirrusSearch/CirrusSearch.php";
wfLoadExtension( 'Elastica' );
wfLoadExtension( 'MsUpload' );
wfLoadExtension( 'MwEmbedSupport' );
wfLoadExtension( 'OpenIDConnect' );
wfLoadExtension( 'PageForms' );
wfLoadExtension( 'PluggableAuth' );
wfLoadExtension( 'ReplaceText' );
require_once "$IP/extensions/SemanticMediaWiki/SemanticMediaWiki.php";
include_once("$IP/extensions/SemanticDrilldown/SemanticDrilldown.php");
require_once "$IP/extensions/TimedMediaHandler/TimedMediaHandler.php";


## Custom Variables
enableSemantics('http://changeme.net');
$wgAllowConfirmedEmail = true;
$wgEnableScaryTranscluding = true;
$wgUseAjax = true;
$wgMaxShellMemory = 512000;
$wgEnableMWSuggest = true;
$wgMaxUploadSize = 2621440000;
$wgFileExtensions = array('png','gif','jpg','jpeg','doc','xls','mpp','pdf','ppt','tiff','bmp','docx', 'xlsx', 'pptx','ps','odt','oft','ods','odp','odg','vsd','nxs','pem','crt','mp4','tar','zip','gz','7z','tgz');
##MsUpload
$wgMSU_ShowAutoKat = false;    #autocategorisation
$wgMSU_CheckedAutoKat = false;  #checkbox: checked = true/false
$wgMSU_debug = false;
$wgMSU_UseDragDrop = true;
##End  --------------------------------------- MsUpload
$wgExternalLinkTarget = '_blank';
$wgGroupPermissions['bureaucrat']['replacetext'] = true;
$wgEnableTranscode = false;
#$wgFFmpeg2theoraLocation = '/usr/bin/ffmpeg2theora';
$wgFFmpegLocation = '/usr/bin/ffmpeg';
########## Elastic Search ############
#$wgDisableSearchUpdate = true;
$wgCirrusSearchServers = array( 'wiki_elasticsearch_01', 'wiki_elasticsearch_02', 'wiki_elasticsearch_03' );
$wgSearchType = 'CirrusSearch';
$wgJobRunRate = 0.05;
########## Elastic Search End ############
########## Pdf Handler #################
$wgPdfProcessor = '/usr/bin/gs';
$wgPdfPostProcessor = '/usr/bin/convert';
$wgPdfInfo = '/usr/bin/pdfinfo';
$wgPdftoText = '/usr/bin/pdftotext';
############ END ################
########## Remote authentication #################
# ADFS attributes: https://adfs.changeme.net/adfs/.well-known/openid-configuration
# redirect URI: https://changeme.net/index.php/Special:PluggableAuthLogin
$wgArticlePath = '/index.php/$1'; # Ensure article path is set to allow re-direct from adfs.
$wgPluggableAuth_EnableAutoLogin = true;
$wgPluggableAuth_EnableLocalLogin = false;
$wgOpenIDConnect_MigrateUsersByUserName = true;
$wgPluggableAuth_Class = "OpenIDConnect";
$wgOpenIDConnect_Config['https://adfs.changeme.net/adfs'] = array(
	'clientID' => '?????????????',
	'clientsecret' => '???????????????',
	'scope' => [ 'openid', 'profile', 'email' ],
	);                                         
############ END ################

$egChameleonLayoutFile= __DIR__ . '/skins/chameleon/layouts/custom.xml';
## Debug
$wgShowExceptionDetails = true; 
?>