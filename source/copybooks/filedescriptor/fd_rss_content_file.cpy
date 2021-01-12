      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2021-01-12
      * Purpose: File description for RSS content files.
      * Tectonics: ./build.sh
      ******************************************************************
           FD fd-rss-content-file.
           01  f-rss-content-record.
               05  f-feed-id                    pic 9(5) values zeros.
               05  f-feed-title                 pic x(128) value spaces.
               05  f-feed-site-link             pic x(256) value spaces.
               05  f-feed-desc                  pic x(256) value spaces.
               05  f-items                      occurs 30 times.
                   10  f-item-exists            pic a value 'N'.
                   10  f-item-title             pic x(128) value spaces.
                   10  f-item-link              pic x(256) value spaces.
                   10  f-item-guid              pic x(256) value spaces.
                   10  f-item-pub-date          pic x(128) value spaces.
                   10  f-item-desc              pic x(512) value spaces.
