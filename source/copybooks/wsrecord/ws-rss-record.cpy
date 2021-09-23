      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2021-09-23
      * Purpose: Working storage definition of RSS content files defined
      *          in the rss_content_file file descriptor.
      * Tectonics: ./build.sh
      ******************************************************************
       78  ws-max-rss-items                     value 15000.
       77  ws-num-items-disp                    pic 9(6).
       
       01  ws-rss-record.
           05  ws-feed-id                       pic 9(5) value zeros.
           05  ws-feed-title                    pic x(128) value spaces.
           05  ws-feed-site-link                pic x(256) value spaces.
           05  ws-feed-desc                     pic x(256) value spaces.
           05  ws-num-items                     pic 9(6) value 0.           
           05  ws-items              occurs 0 to ws-max-rss-items times 
                                     depending on ws-num-items.
               10 ws-item-title                 pic x(128) value spaces.
               10 ws-item-link                  pic x(256) value spaces.
               10 ws-item-guid                  pic x(256) value spaces.
               10 ws-item-pub-date              pic x(128) value spaces.
               10 ws-item-desc                  pic x(512) value spaces.
