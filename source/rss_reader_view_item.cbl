      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-19
      * Last Modified: 2020-12-19
      * Purpose: RSS Reader Item Viewer - Displays formatted feed
      *          item data
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-view-item.

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

       77  empty-line                                pic x(80) 
                                                     value spaces. 
      
      * Value set based on file name passed in linkage section.
       77  ws-rss-content-file-name                  pic x(255) 
                                                     value spaces.
      
       78  new-line                                  value x"0a".

       linkage section.
           01  ls-rss-content-file-name         pic x(255).

       screen section.
       
       copy "./screens/rss_item_screen.cpy".
       copy "./screens/blank_screen.cpy".

       procedure division using ls-rss-content-file-name.
       main-procedure.

           display blank-screen 

           display "viewing: " function trim(ls-rss-content-file-name)

           if not ls-rss-content-file-name = spaces then 
               move ls-rss-content-file-name to ws-rss-content-file-name
               perform view-feed-data

               accept rss-item-screen
           else 
               display "ERROR: No feed file passed to feed viewer."
               move spaces to ws-rss-record
               move "File name passed was empty" to ws-feed-title
               accept rss-item-screen
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
                       display function trim(ws-feed-title)
                       display function trim(item-title(1))
                   end-read
               end-perform
           close rss-content-file

           exit paragraph.

       end program rss-reader-view-item.
