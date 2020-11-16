      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2020-11-10
      * Purpose: File description for RSS content files.
      * Tectonics: ./build.sh
      ******************************************************************
           FD rss-content-file.
           01  rss-content-record.
               05  feed-id                      pic 9(5) values zeros.
               05  feed-title                   pic x(128) value spaces.
               05  feed-link                    pic x(256) value spaces.
               05  feed-desc                    pic x(256) value spaces.
               05  items                        occurs 30 times.
                   10  item-exists              pic a value 'N'.
                   10  item-title               pic x(128) value spaces.
                   10  item-link                pic x(256) value spaces.
                   10  item-guid                pic x(256) value spaces.
                   10  item-pub-date            pic x(128) value spaces.
                   10  item-desc                pic x(512) value spaces.
