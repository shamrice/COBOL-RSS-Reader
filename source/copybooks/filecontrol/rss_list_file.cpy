      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2021-01-12
      * Purpose: File control definition for file that maintains the 
      *          connection between the id, feed url and RSS content
      *          file name for each RSS feed.
      * Tectonics: ./build.sh
      ******************************************************************
               select optional fd-rss-list-file
               assign to dynamic ws-rss-list-file-name
               organization is indexed
               access is dynamic
               record key is f-rss-link
               alternate record key is f-rss-feed-id.               
