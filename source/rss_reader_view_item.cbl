      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-19
      * Last Modified: 2021-09-23
      * Purpose: RSS Reader Item Viewer - Displays formatted feed
      *          item data
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-view-item.

       environment division.
       
       configuration section.
       special-names.
           cursor is ws-cursor-position      
           crt status is ws-crt-status.

       input-output section.

       data division.
       file section.

       working-storage section.

       copy "screenio.cpy".

       01  ws-cursor-position. 
           05  ws-cursor-line                        pic 99. 
           05  ws-cursor-col                         pic 99. 

       01  ws-crt-status. 
           05  ws-key1                       pic x. 
           05  ws-key2                       pic x. 
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

       01  ws-exit-sw                        pic a value 'N'.
           88  ws-exit-true                  value 'Y'.
           88  ws-exit-false                 value 'N'.

       77  ws-empty-line                     pic x(80) value spaces. 

       linkage section.

       01  l-feed-title                      pic x any length.
 
       01  l-feed-site-link                  pic x any length.

       01  l-feed-item.           
           05  l-item-title                  pic x(128) value spaces.
           05  l-item-link                   pic x(256) value spaces.
           05  l-item-guid                   pic x(256) value spaces.
           05  l-item-pub-date               pic x(128) value spaces.
           05  l-item-desc                   pic x(512) value spaces.

       screen section.
       
       copy "./screens/rss_item_screen.cpy".
       copy "./screens/blank_screen.cpy".


       procedure division using 
           l-feed-title, l-feed-site-link, l-feed-item.

       set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
       set environment 'COB_SCREEN_ESC'        TO 'Y'.

       main-procedure.

           display s-blank-screen 

           call "logger" using function concatenate(
               "Viewing feed item: ", l-item-desc)
           end-call 
           
           move l-feed-title to ws-feed-title
           move l-feed-site-link to ws-feed-site-link

           move l-item-title to ws-item-title
           move l-item-link to ws-item-link
           move l-item-guid to ws-item-guid
           move l-item-pub-date to ws-item-pub-date

           move l-item-desc to ws-item-desc-lines

           perform handle-user-input

           display s-blank-screen 
           goback.


       handle-user-input.

           perform until ws-exit-true

               accept s-rss-item-screen

               evaluate true 
                      
                   when ws-key1 = COB-SCR-OK
                       call "browser-launcher" using by content 
                           ws-item-link
                       end-call 
                       cancel "browser-launcher"

                   when ws-crt-status = COB-SCR-ESC
                       set ws-exit-true to true

      *>   Mouse input handling.                   
                   when ws-crt-status = COB-SCR-LEFT-RELEASED
                       perform handle-mouse-click    

               end-evaluate
           end-perform

           exit paragraph.


       handle-mouse-click.
           if ws-cursor-line = 21 then 
               evaluate true
                   when ws-cursor-col >= 6 and ws-cursor-col < 34
                       call "browser-launcher" using by content 
                           ws-item-link
                       end-call 
                       cancel "browser-launcher"    

                   when ws-cursor-col >= 35 and ws-cursor-col < 61 
                       set ws-exit-true to true                                              
               end-evaluate
           end-if 

           exit paragraph.

       end program rss-reader-view-item.
