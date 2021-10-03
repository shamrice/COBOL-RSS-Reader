      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2021-09-29
      * Purpose: File description for file that maintains the 
      *          connection between the id, feed url and RSS content
      *          file name for each RSS feed.
      * Tectonics: ./build.sh
      ******************************************************************
           FD fd-rss-list-file.
           01  f-rss-list-record.               
               05 f-rss-feed-id                pic 9(5) value zeros.
               05 f-rss-feed-status            pic 9 value zero.
               05 f-rss-title                  pic x(128) value spaces.               
               05 f-rss-dat-file-name          pic x(128) value spaces.
               05 f-rss-link                   pic x(256) value spaces.
