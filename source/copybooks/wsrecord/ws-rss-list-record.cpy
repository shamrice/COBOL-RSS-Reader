      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2021-09-29
      * Purpose: Working storage definition for rss_list_record file
      *          descriptor
      * Tectonics: ./build.sh
      ******************************************************************
       01  ws-rss-list-record.           
           05  ws-rss-feed-id                  pic 9(5) value zeros. 
           05  ws-rss-feed-status              pic 9 value zero.          
           05  ws-rss-title                    pic x(128) value spaces.           
           05  ws-rss-dat-file-name            pic x(128) value spaces.
           05  ws-rss-link                     pic x(256) value spaces.
           
