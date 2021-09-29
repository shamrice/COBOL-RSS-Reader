# COBOL RSS Reader - crssr

Console RSS reader application written in GnuCOBOL

## Building 
Run the shell script "build.sh" in the source directory. (Optional "--debug" parameter to create a debug build)

## Running
* Open application in interactive mode and refresh feeds at start:
  ```./crssr```
* Open application in interactive mode and do not refresh feeds at start:
  ```./crssr --no-refresh```
* Open application in interactive mode and enable logging: 
  ```./crssr --logging=true```
* Open application in interactive mode and disable logging (default if not set):
  ```./crssr --logging=false```
* Remove all current feeds by deleting data files in feeds directory:
  ```./crssr --reset```
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
  * GnuCOBOL installed >= 3.1.2.0
  * wget or curl installed  
  * lynx or links installed - optional - used to open RSS item in web browser  
  * xterm installed - optional - used to open web browser in new terminal window
  * xmllint installed - optional - will be used if exists to attempt to format minified RSS feed XML to reparse.
  * Linux(?) - Build script is written for Linux but can be modified to compile on other operating systems if needed.
  
## Current Limitations:
RSS Feeds must be properly formatted application/rss+xml. Some RSS feeds will minify the data into a single line. 
If xmllint is installed, a second parse attempt will be attempted to properly format the RSS XML so that it can be 
parsed. If xmllint is not installed, RSS XML must be formatted correctly in order to be parsed.

Example of a properly formatted RSS feed: https://www.rssboard.org/files/sample-rss-2.xml

## Screen Shots:
*Main RSS Feed List:*
![RSS Feed List](https://i.imgur.com/875Qg6z.png)

*Viewing items in feed:*
![RSS Feed Items](https://i.imgur.com/eHJeVhL.png)

*View feed item:*
![Feed Item](https://i.imgur.com/6R7msIE.png)

*Add feed window:*
![Add feed window](https://i.imgur.com/2Fyjerp.png)
