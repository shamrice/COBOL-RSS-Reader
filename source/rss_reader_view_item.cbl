      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-19
      * Last Modified: 2020-12-30
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

       01  ws-feed-header-lines.
           05  ws-feed-title                 pic x(128).
           05  ws-feed-site-link             pic x(256).

       01  ws-item-header-lines.
           05  ws-item-title                 pic x(128) value spaces.
           05  ws-item-link                  pic x(256) value spaces.
           05  ws-item-guid                  pic x(256) value spaces.
           05  ws-item-pub-date              pic x(128) value spaces.       
   
       01  ws-item-desc-lines.
           05  ws-desc-line                  pic x(70) value spaces     
                                             occurs 8 times.

       77  empty-line                        pic x(80) value spaces. 
       78  new-line                          value x"0a".

       linkage section.

       01  ls-feed-title                     pic x any length.

       01  ls-feed-site-link                 pic x any length.

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
               "Viewing feed item: ", ls-item-desc)
           end-call 
           
           move ls-feed-title to ws-feed-title
           move ls-feed-site-link to ws-feed-site-link

           move ls-item-title to ws-item-title
           move ls-item-link to ws-item-link
           move ls-item-guid to ws-item-guid
           move ls-item-pub-date to ws-item-pub-date

           move ls-item-desc to ws-item-desc-lines

           accept rss-item-screen

           display blank-screen 
           goback.

       end program rss-reader-view-item.
