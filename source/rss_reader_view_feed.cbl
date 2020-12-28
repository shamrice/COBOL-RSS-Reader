      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2020-12-28
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
           cursor is cursor-position        
           crt status is crt-status.

       input-output section.
           file-control.               
               copy "./copybooks/filecontrol/rss_content_file.cpy".

       data division.
       file section.
           copy "./copybooks/filedescriptor/fd_rss_content_file.cpy".
          
       working-storage section.

       copy "screenio.cpy".
       copy "./copybooks/wsrecord/ws-rss-record.cpy".
            
       01  cursor-position. 
           05  cursor-line                           pic 99. 
           05  cursor-col                            pic 99. 
        
       01  crt-status. 
           05  key1                                  pic x. 
           05  key2                                  pic x. 
           05  filler                                pic x. 
           05  filler                                pic x.


       01  ws-accept-item                            pic x value space.

       01  eof-sw                                    pic a value 'N'.
           88  eof                                   value 'Y'.
           88  not-eof                               value 'N'.

       01  exit-sw                                   pic a value 'N'.
           88  exit-true                             value 'Y'.
           88  exit-false                            value 'N'.

       77  empty-line                                pic x(80) 
                                                     value spaces. 
       77  ws-selected-id                       pic 9(5) value zeros.

      * Value set based on file name passed in linkage section.
       77  ws-rss-content-file-name                  pic x(255) 
                                                     value spaces.
      
       78  new-line                                  value x"0a".

       linkage section.
           01  ls-rss-content-file-name              pic x(255).

       screen section.
       
       copy "./screens/rss_info_screen.cpy".
       copy "./screens/blank_screen.cpy".

       procedure division using ls-rss-content-file-name.
       
       main-procedure.
      
           display blank-screen 

           call "logger" using function concatenate(
               "viewing: ", function trim(ls-rss-content-file-name))
           end-call

           if not ls-rss-content-file-name = spaces then 
               move ls-rss-content-file-name to ws-rss-content-file-name
               perform load-feed-data
               perform handle-user-input
           else 
               call "logger" using 
                   "ERROR: No feed file passed to feed viewer."
               end-call
               move spaces to ws-rss-record
               move "File name passed was empty" to ws-feed-title
               accept rss-info-screen
           end-if

           display blank-screen 

           goback.
  
       handle-user-input.

           perform until exit-true

               accept rss-info-screen

               evaluate true 
                      
                   when key1 = COB-SCR-OK
                       perform view-selected-feed-item
              
                   when crt-status = COB-SCR-F10
                       move 'Y' to exit-sw
                       
               end-evaluate
           end-perform

           exit paragraph.


       view-selected-feed-item.

      * 3 is line offset to account for header lines.
           compute ws-selected-id = cursor-line - 3
           
           if ws-selected-id <= ws-max-rss-items then
               if ws-item-exists(ws-selected-id) = 'Y' then

                   call "logger" using function concatenate(
                       "Selected item ID to view is: ", 
                       ws-selected-id)
                   end-call

                   call "logger" using function concatenate(
                       "Item: ", ws-items(ws-selected-id))
                   end-call

               else 
                   call "logger" using function concatenate(
                       "selected item does not exist:",
                       ws-selected-id)
                   end-call 
               end-if
           end-if

           exit paragraph.


       load-feed-data.
       
           open input rss-content-file
               perform until eof
                   read rss-content-file into ws-rss-record
                       at end move 'Y' to eof-sw
                   not at end
                       call "logger" using function concatenate(
                           "Viewing feed data items for feed: ",
                           function trim(ws-feed-title))
                       end-call
                   end-read
               end-perform
           close rss-content-file

           exit paragraph.

       end program rss-reader-view-feed.
