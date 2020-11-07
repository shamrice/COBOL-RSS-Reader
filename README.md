# COBOL RSS Reader - crssr

Command line RSS reader written in GnuCOBOL

Project just started... not much to see so far.

## Building 
Run the shell script "build.sh" in the source directory.

## Running
* Download and parse an RSS feed: 
  ```./crssr [url of rss feed]```
* Display parsed feeds:
  ``` ./crssr ```
* Display usage help:
  ``` ./crssr --help ```

## Libraries used: 
  * cobweb-pipes - https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/tools/cobweb/cobweb-pipes/
  
## Build/Run Prerequisites 
  * GnuCOBOL installed
  * wget installed
  * Linux(?) - I haven't tried build or run on Windows or Mac.
  
## Current Limitations:
RSS Feeds must be properly formatted application/rss+xml. Some RSS feeds will minify the data into a single line. This application cannot currently handle RSS feeds that are minified and do not have a new line after each tag. 

Example of a properly formatted RSS feed: https://www.rssboard.org/files/sample-rss-2.xml

  
