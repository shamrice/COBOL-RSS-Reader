      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-02
      * Last Modified: 2021-09-22
      * Purpose: RSS Reader Add Feed - Screen sub program to add feeds
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-add-feed.

       environment division.
       
       configuration section.

       repository.
           function rss-downloader.

       special-names.
           crt status is ws-crt-status.

       input-output section.

       data division.
       file section.

       working-storage section.

       copy "screenio.cpy".

       01  ws-crt-status. 
           05  ws-key1                       pic x. 
           05  ws-key2                       pic x. 
           05  filler                        pic x. 
           05  filler                        pic x.

       01  ws-rss-url                        pic x(256) value space.

       01  ws-add-feed-status                pic 9 value zero.

       01  ws-message-screen-fields.
           05  ws-msg-title                  pic x(70) value spaces.
           05  ws-msg-body                   occurs 2 times.
               10  ws-msg-body-text          pic x(70) value spaces.
           05  ws-msg-input                  pic x value space.
         
       01  ws-exit-sw                        pic a value 'N'.
           88  ws-exit-true                  value 'Y'.
           88  ws-exit-false                 value 'N'.

       77  ws-empty-line                     pic x(80) value spaces. 

       linkage section.

       screen section.
       
       copy "./screens/blank_screen.cpy".
       copy "./screens/rss_add_feed_screen.cpy".
       copy "./screens/message_screen.cpy".

       procedure division.
       set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
       set environment 'COB_SCREEN_ESC'        TO 'Y'.
      
       main-procedure.

           move "Add Feed Status" to ws-msg-title

           perform handle-user-input

           display s-blank-screen 
           goback.


       handle-user-input.

           perform until ws-exit-true

               accept s-rss-add-feed-screen 

               evaluate true 
                      
                   when ws-key1 = COB-SCR-OK
                       call "logger" using ws-rss-url

                       move function rss-downloader(ws-rss-url)
                           to ws-add-feed-status
                       if ws-add-feed-status = 1 then 
                           move "New RSS feed added successfully." to
                               ws-msg-body-text(1)
                       else 
                           move function concatenate(
                               "Downloading and parsing RSS feed ",
                               "failed.")
                               to ws-msg-body-text(1)

                           move function concatenate(
                               "Please check logs. Status: ", 
                               ws-add-feed-status)
                               to ws-msg-body-text(2)
                       end-if    

                       accept s-message-screen
                       set ws-exit-true to true 
                    
                   when ws-crt-status = COB-SCR-ESC
                       set ws-exit-true to true 
                       
               end-evaluate
           end-perform

           exit paragraph.

       end program rss-reader-add-feed.
