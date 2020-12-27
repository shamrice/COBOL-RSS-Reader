#!/bin/bash

#
# Last updated: 2020-12-19
#
# Builds sets placeholder values in source code based on variables at start of script 
# and compiles the application. Once compilation step is completed, placeholders are 
# set back to original placeholder values.
#

echo Building COBOL RSS Reader...

APP_VERSION=0.11
SOURCE_URL=\"https\\:\\/\\/github.com\\/shamrice\\/COBOL-RSS-Reader\"
CUR_BUILD_DATE=\"$(date +%Y-%m-%d)\"

echo Replacing placeholders in source with values for build process.
sed -i "s/__APP_VERSION/$APP_VERSION/" crssr.cbl
sed -i "s/__SOURCE_URL/$SOURCE_URL/" crssr.cbl
sed -i "s/__BUILD_DATE/$CUR_BUILD_DATE/" crssr.cbl

echo Compiling...
cobc -x crssr.cbl rss_parser.cbl rss_reader_menu.cbl rss_reader_view_feed.cbl rss_reader_view_item.cbl rss_downloader.cbl logger.cbl cobweb-pipes.cob -o crssr 

echo Setting placeholders back to placeholder names for next build.
sed -i "s/$APP_VERSION/__APP_VERSION/" crssr.cbl
sed -i "s/$SOURCE_URL/__SOURCE_URL/" crssr.cbl
sed -i "s/$CUR_BUILD_DATE/__BUILD_DATE/" crssr.cbl

echo Done.
