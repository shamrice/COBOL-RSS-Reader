      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2020-11-21
      * Purpose: Working storage definition of RSS content files defined
      *          in the rss_content_file file descriptor.
      * Tectonics: ./build.sh
      ******************************************************************
       78  ws-max-rss-items                     value 30.
       
       01  ws-rss-record.
           05  ws-feed-id                       pic 9(5) value zeros.
           05  ws-feed-title                    pic x(128) value spaces.
           05  ws-feed-site-link                pic x(256) value spaces.
           05  ws-feed-desc                     pic x(256) value spaces.
           05  ws-items                   occurs ws-max-rss-items times.
               10 ws-item-exists                pic a value 'N'.
               10 ws-item-title                 pic x(128) value spaces.
               10 ws-item-link                  pic x(256) value spaces.
               10 ws-item-guid                  pic x(256) value spaces.
               10 ws-item-pub-date              pic x(128) value spaces.
               10 ws-item-desc                  pic x(512) value spaces.
