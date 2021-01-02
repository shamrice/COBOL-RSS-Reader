      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-19
      * Last Modified: 2021-01-02
      * Purpose: RSS Reader Item Viewer - Displays formatted feed
      *          item data
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-view-item.

       environment division.
       
       configuration section.
       special-names.
           crt status is crt-status.

       input-output section.

       data division.
       file section.

       working-storage section.

       copy "screenio.cpy".

       01  crt-status. 
           05  key1                          pic x. 
           05  key2                          pic x. 
           05  filler                        pic x. 
           05  filler                        pic x.

       01  ws-accept-item                    pic x value space.

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

       01  exit-sw                           pic a value 'N'.
           88  exit-true                     value 'Y'.
           88  exit-false                    value 'N'.

       77  empty-line                        pic x(80) value spaces. 

       77  launch-status                     pic 9 value 9.
      
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

           perform handle-user-input

           display blank-screen 
           goback.


       handle-user-input.

           perform until exit-true

               accept rss-item-screen

               evaluate true 
                      
                   when key1 = COB-SCR-OK
                       call "browser-launcher" using by content 
                           ws-item-link
                       end-call 
                       cancel "browser-launcher"

                   when crt-status = COB-SCR-F10
                       move 'Y' to exit-sw
                       
               end-evaluate
           end-perform

           exit paragraph.

       end program rss-reader-view-item.
