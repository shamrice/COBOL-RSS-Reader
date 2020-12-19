#!/bin/bash

echo Building COBOL RSS Reader...
cobc -x crssr.cbl rss_parser.cbl rss_reader_menu.cbl rss_reader_view_feed.cbl rss_reader_view_item.cbl cobweb-pipes.cob -o crssr 
echo Done.
