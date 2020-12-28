      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-19
      * Last Modified: 2020-12-28
      * Purpose: RSS Reader Item Viewer - Displays formatted feed
      *          item data
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-view-item.

       environment division.
       
       configuration section.

       input-output section.

       data division.
       file section.

       working-storage section.

       copy "screenio.cpy".
       
       01  ws-accept-item                            pic x value space.

       77  empty-line                                pic x(80) 
                                                     value spaces. 
            
       78  new-line                                  value x"0a".

       linkage section.

       01  ls-feed-title                             pic x(128).

       01  ls-feed-site-link                         pic x(256).

       01  ls-feed-item.
           05  ls-item-exists                pic a value 'N'.
           05  ls-item-title                 pic x(128) value spaces.
           05  ls-item-link                  pic x(256) value spaces.
           05  ls-item-guid                  pic x(256) value spaces.
           05  ls-item-pub-date              pic x(128) value spaces.
           05  ls-item-desc                  pic x(512) value spaces.


       screen section.
       
       copy "./screens/rss_item_screen.cpy".
       copy "./screens/blank_screen.cpy".


       procedure division using 
           ls-feed-title, ls-feed-site-link, ls-feed-item.

       main-procedure.

           display blank-screen 

           call "logger" using function concatenate(
               "Viewing feed item: ", ls-feed-item)
           end-call 

           accept rss-item-screen

           display blank-screen 
           goback.

       end program rss-reader-view-item.
