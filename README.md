# COBOL RSS Reader - crssr

Console RSS reader application written in GnuCOBOL

## Building 
Run the shell script "build.sh" in the source directory.

## Running
* Open application in interactive mode and refresh feeds at start:
  ```./crssr```
* Open application in interactive mode and do not refresh feeds at start:
  ```./crssr --no-refresh``
* Open application in interactive mode and enable logging: 
  ```./crssr --logging=true```
* Open application in interactive mode and disable logging (default if not set):
  ```./crssr --logging=false```
* Download and parse an RSS feed into feed list: 
  ```./crssr -a [url of rss feed]```
* Delete existing RSS feed from feed list:
  ```./crssr -d [url of rss feed]```
* Export an existing RSS feed from feed list: 
  ```./crssr -o [output filename] [url of rss feed]```
* Display usage help:
  ``` ./crssr --help ```

## Libraries used: 
  * cobweb-pipes - https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/tools/cobweb/cobweb-pipes/
  
## Build/Run Prerequisites 
  * GnuCOBOL installed
  * wget installed
  * lynx installed - optional - used to open RSS item in browser
  * Linux(?) - Build script is written for Linux but can be modified to compile on other operating systems if needed.
  
## Current Limitations:
RSS Feeds must be properly formatted application/rss+xml. Some RSS feeds will minify the data into a single line. This application cannot currently handle RSS feeds that are minified and do not have a new line after each tag. 

Example of a properly formatted RSS feed: https://www.rssboard.org/files/sample-rss-2.xml

  
