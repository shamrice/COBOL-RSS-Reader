#!/bin/bash

#
# Last updated: 2021-10-05
#
# Builds sets placeholder values in source code based on variables at start of script 
# and compiles the application. Once compilation step is completed, placeholders are 
# set back to original placeholder values.
#


APP_VERSION=\"v0.48\"
SOURCE_URL=\"https\\:\\/\\/github.com\\/shamrice\\/COBOL-RSS-Reader\"
CUR_BUILD_DATE=\"$(date +%Y-%m-%d)\"

echo 
echo Building COBOL RSS Reader
echo --------------------------
echo Version: $APP_VERSION 
echo Build Date: $CUR_BUILD_DATE
echo 

DEBUG=""

if [[ "$1" == "--debug" ]]
then 
    DEBUG=$1
    echo Debug flag set. Adding $1 to build arguements. 
fi 


echo Replacing placeholders in source with values for build process.
sed -i "s/__APP_VERSION/$APP_VERSION/" crssr.cbl
sed -i "s/__SOURCE_URL/$SOURCE_URL/" crssr.cbl
sed -i "s/__BUILD_DATE/$CUR_BUILD_DATE/" crssr.cbl
sed -i "s/__APP_VERSION/$APP_VERSION/" rss_reader_help.cbl
sed -i "s/__SOURCE_URL/$SOURCE_URL/" rss_reader_help.cbl
sed -i "s/__BUILD_DATE/$CUR_BUILD_DATE/" rss_reader_help.cbl

echo Compiling...
echo 
BUILD_STRING="cobc -O2 -fstatic-call -x $DEBUG crssr.cbl rss_parser.cbl rss_reader_menu.cbl rss_reader_view_feed.cbl rss_reader_view_item.cbl rss_downloader.cbl browser_launcher.cbl rss_reader_add_feed.cbl rss_reader_delete_feed.cbl rss_reader_help.cbl rss_reader_export_feed.cbl rss_report_writer.cbl remove_rss_record.cbl logger.cbl string_helpers.cbl application_configurator.cbl reset_files.cbl cobweb-pipes.cob rss_reader_configuration.cbl -o crssr"
echo $BUILD_STRING 
echo 
$BUILD_STRING
echo 


echo Setting placeholders back to placeholder names for next build.
sed -i "s/$APP_VERSION/__APP_VERSION/" crssr.cbl
sed -i "s/$SOURCE_URL/__SOURCE_URL/" crssr.cbl
sed -i "s/$CUR_BUILD_DATE/__BUILD_DATE/" crssr.cbl
sed -i "s/$APP_VERSION/__APP_VERSION/" rss_reader_help.cbl
sed -i "s/$SOURCE_URL/__SOURCE_URL/" rss_reader_help.cbl
sed -i "s/$CUR_BUILD_DATE/__BUILD_DATE/" rss_reader_help.cbl

echo
echo Done.
echo
