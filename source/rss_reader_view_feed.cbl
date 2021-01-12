      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2021-01-12
      * Purpose: RSS Reader Feed Viewer - Displays formatted feed data
      *  Cancel subprogram after each run to ensure that variables are 
      *  reset and loaded fresh at start up.
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-view-feed.

       environment division.
       
       configuration section.
       special-names.
           cursor is ws-cursor-position        
           crt status is ws-crt-status.

       input-output section.
           file-control.               
               copy "./copybooks/filecontrol/rss_content_file.cpy".

       data division.
       file section.
           copy "./copybooks/filedescriptor/fd_rss_content_file.cpy".
          
       working-storage section.

       copy "screenio.cpy".
       copy "./copybooks/wsrecord/ws-rss-record.cpy".
            
       01  ws-cursor-position. 
           05  ws-cursor-line                        pic 99. 
           05  ws-cursor-col                         pic 99. 
        
       01  ws-crt-status. 
           05  ws-key1                               pic x. 
           05  ws-key2                               pic x. 
           05  filler                                pic x. 
           05  filler                                pic x.

       01  ws-accept-item                            pic x value space.

       01  ws-eof-sw                                 pic a value 'N'.
           88  ws-eof                                value 'Y'.
           88  ws-not-eof                            value 'N'.

       01  ws-exit-sw                                pic a value 'N'.
           88  ws-exit-true                          value 'Y'.
           88  ws-exit-false                         value 'N'.

       77  empty-line                                pic x(80) 
                                                     value spaces. 
       77  ws-selected-id                       pic 9(5) value zeros.

      * Value set based on file name passed in linkage section.
       77  ws-rss-content-file-name                  pic x(255) 
                                                     value spaces.
      
       linkage section.
           01  l-rss-content-file-name               pic x(255).

       screen section.
       
       copy "./screens/rss_info_screen.cpy".
       copy "./screens/blank_screen.cpy".

       procedure division using l-rss-content-file-name.
       set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
       set environment 'COB_SCREEN_ESC'        TO 'Y'.


       main-procedure.
      
           display s-blank-screen 

           call "logger" using function concatenate(
               "viewing: ", function trim(l-rss-content-file-name))
           end-call

           if not l-rss-content-file-name = spaces then 
               move l-rss-content-file-name to ws-rss-content-file-name
               perform load-feed-data
               perform handle-user-input
           else 
               call "logger" using 
                   "ERROR: No feed file passed to feed viewer."
               end-call
               move spaces to ws-rss-record
               move "File name passed was empty" to ws-feed-title
               accept s-rss-info-screen
           end-if

           display s-blank-screen 

           goback.
  
       handle-user-input.

           perform until ws-exit-true

               accept s-rss-info-screen

               evaluate true 
                      
                   when ws-key1 = COB-SCR-OK
                       perform view-selected-feed-item
              
                   when ws-crt-status = COB-SCR-ESC
                       set ws-exit-true to true 
                       
               end-evaluate
           end-perform

           exit paragraph.


       view-selected-feed-item.

      * 4 is line offset to account for header lines.
           compute ws-selected-id = ws-cursor-line - 4
           
           if ws-selected-id <= ws-max-rss-items then
               if ws-item-exists(ws-selected-id) = 'Y' then

                   call "logger" using function concatenate(
                       "Selected item ID to view is: ", 
                       ws-selected-id)
                   end-call

                   call "logger" using function concatenate(
                       "Item: ", ws-items(ws-selected-id))
                   end-call

                   call "rss-reader-view-item" using by content 
                       ws-feed-title,
                       ws-feed-site-link,
                       ws-items(ws-selected-id)
                   end-call
                   cancel "rss-reader-view-item"

               else 
                   call "logger" using function concatenate(
                       "selected item does not exist:",
                       ws-selected-id)
                   end-call 
               end-if
           end-if

           exit paragraph.


       load-feed-data.
       
           open input fd-rss-content-file
               perform until ws-eof
                   read fd-rss-content-file into ws-rss-record
                       at end set ws-eof to true 
                   not at end
                       call "logger" using function concatenate(
                           "Viewing feed data items for feed: ",
                           function trim(ws-feed-title))
                       end-call
                   end-read
               end-perform
           close fd-rss-content-file

           exit paragraph.

       end program rss-reader-view-feed.
