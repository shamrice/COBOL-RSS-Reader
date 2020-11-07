#!/bin/bash

echo Building COBOL RSS Reader...
cobc -x rss_reader.cbl rss_parser.cbl cobweb-pipes.cob -o crssr
echo Done.
