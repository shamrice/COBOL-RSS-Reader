      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2021-09-23
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

       77  ws-empty-line                             pic x(80) 
                                                     value spaces. 
       77  ws-selected-id                       pic 9(5) value zeros.    

      * Value set based on file name passed in linkage section.
       77  ws-rss-content-file-name                  pic x(255) 
                                                     value spaces.

       77  ws-idx                                    pic 9(6) comp.       

       local-storage section. 
       01  ls-display-item-title                pic x(128) value spaces
                                                occurs 15 times.

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

           if l-rss-content-file-name not = spaces then 
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

      *>   Mouse input handling.                   
                   when ws-crt-status = COB-SCR-LEFT-RELEASED
                       perform handle-mouse-click     

               end-evaluate
           end-perform

           exit paragraph.


       handle-mouse-click.
           if ws-cursor-line = 21 and ws-cursor-col >= 35 
           and ws-cursor-col < 59 then 
               set ws-exit-true to true                
           end-if 

           if ws-cursor-line < 20 then                 
               perform view-selected-feed-item
           end-if 

           exit paragraph.


       view-selected-feed-item.

      * 4 is line offset to account for header lines.
           if ws-cursor-line not > 4 then 
               exit paragraph
           end-if 

           compute ws-selected-id = ws-cursor-line - 4
           
           move ws-num-items to ws-num-items-disp
           call "logger" using function concatenate(
                   "Selected item ID to view is: ", 
                   ws-selected-id " max: " ws-max-rss-items 
                   " num items: " ws-num-items-disp)
           end-call  

           if ws-selected-id > 0 and ws-selected-id <= ws-max-rss-items 
           and ws-selected-id <= ws-num-items then

               call "logger" using function concatenate(
                   "Selected item ID to view is: ", 
                   ws-selected-id, " Item: ", ws-items(ws-selected-id))
               end-call

               call "rss-reader-view-item" using by content 
                   ws-feed-title,
                   ws-feed-site-link,
                   ws-items(ws-selected-id)
               end-call
               cancel "rss-reader-view-item"
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

           *> move item titles from data file if they are present.
           if ws-num-items > 0 then 
               perform varying ws-idx from 1 by 1 
               until ws-idx > ws-num-items or ws-idx > 15

                   move ws-item-title(ws-idx) 
                       to ls-display-item-title(ws-idx)

               end-perform 
           end-if

           exit paragraph.

       end program rss-reader-view-feed.
