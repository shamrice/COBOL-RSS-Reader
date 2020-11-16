      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2020-11-16
      * Purpose: File description for file that maintains the 
      *          connection between the id, feed url and RSS content
      *          file name for each RSS feed.
      * Tectonics: ./build.sh
      ******************************************************************
           FD rss-list-file.
           01  rss-list-record.               
               05 rss-feed-id                  pic 9(5) value zeros.
               05 rss-title                    pic x(128) value spaces.               
               05 rss-dat-file-name            pic x(128) value spaces.
               05 rss-link                     pic x(256) value spaces.
