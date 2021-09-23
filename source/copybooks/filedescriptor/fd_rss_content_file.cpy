      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2021-09-23
      * Purpose: File description for RSS content files.
      * Tectonics: ./build.sh
      ******************************************************************
           FD fd-rss-content-file.
           01  f-rss-content-record.
               05  f-feed-id                  pic 9(5) values zeros.
               05  f-feed-title               pic x(128) value spaces.
               05  f-feed-site-link           pic x(256) value spaces.
               05  f-feed-desc                pic x(256) value spaces.
               05  f-num-items                pic 9(6) value 0.               
               05  f-items                    occurs 0 to 15000 times 
                                              depending on f-num-items.              
                   10  f-item-title          pic x(128) value spaces.
                   10  f-item-link           pic x(256) value spaces.
                   10  f-item-guid           pic x(256) value spaces.
                   10  f-item-pub-date       pic x(128) value spaces.
                   10  f-item-desc           pic x(512) value spaces.
