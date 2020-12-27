      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2020-12-27
      * Purpose: RSS Reader Feed Viewer - Displays formatted feed data
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-view-feed.

       environment division.
       
       configuration section.

       input-output section.
           file-control.               
               copy "./copybooks/filecontrol/rss_content_file.cpy".

       data division.
       file section.

           copy "./copybooks/filedescriptor/fd_rss_content_file.cpy".
          

       working-storage section.

       copy "screenio.cpy".
       copy "./copybooks/wsrecord/ws-rss-record.cpy".
       
       01  accept-item1                              pic x value space.

       01  eof-sw                                    pic a value 'N'.
           88  eof                                   value 'Y'.
           88  not-eof                               value 'N'.

       77  ws-counter                                pic 99 value zeros.

       77  empty-line                                pic x(80) 
                                                     value spaces. 
      
      * Value set based on file name passed in linkage section.
       77  ws-rss-content-file-name                  pic x(255) 
                                                     value spaces.
      
       78  new-line                                  value x"0a".

       linkage section.
           01  ls-rss-content-file-name         pic x(255).

       screen section.
       
       copy "./screens/rss_info_screen.cpy".
       copy "./screens/blank_screen.cpy".

       procedure division using ls-rss-content-file-name.
       main-procedure.
           perform reset-screen-items

           display blank-screen 

           call "logger" using function concatenate(
               "viewing: ", function trim(ls-rss-content-file-name))
           end-call

           if not ls-rss-content-file-name = spaces then 
               move ls-rss-content-file-name to ws-rss-content-file-name
               perform view-feed-data

               accept rss-info-screen
           else 
               call "logger" using 
                   "ERROR: No feed file passed to feed viewer."
               end-call
               move spaces to ws-rss-record
               move "File name passed was empty" to ws-feed-title
               accept rss-info-screen
           end-if

           move spaces to ws-rss-content-file-name
           move spaces to ls-rss-content-file-name
           move  'N' to eof-sw

           display blank-screen 

           goback.


       view-feed-data.
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


       reset-screen-items.
           move 1 to ws-counter
           perform until ws-counter = ws-max-rss-items
               move 'N' to ws-item-exists(ws-counter)
               move spaces to ws-item-title(ws-counter)
               move spaces to ws-item-link(ws-counter)
               move spaces to ws-item-guid(ws-counter)
               move spaces to ws-item-pub-date(ws-counter)
               move spaces to ws-item-desc(ws-counter)

               add 1 to ws-counter
           end-perform
           
           exit paragraph.

       end program rss-reader-view-feed.
