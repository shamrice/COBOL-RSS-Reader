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
      *     file-control.               
      *         copy "./copybooks/filecontrol/rss_content_file.cpy".

       data division.
       file section.

      *     copy "./copybooks/filedescriptor/fd_rss_content_file.cpy".
          

       working-storage section.

       copy "screenio.cpy".
      * copy "./copybooks/wsrecord/ws-rss-record.cpy".
       
       01  ws-accept-item                            pic x value space.

      * 01  eof-sw                                    pic a value 'N'.
      *     88  eof                                   value 'Y'.
      *     88  not-eof                               value 'N'.

       77  empty-line                                pic x(80) 
                                                     value spaces. 
      
      * Value set based on file name passed in linkage section.
      * 77  ws-rss-content-file-name                  pic x(255) 
      *                                               value spaces.
      
       78  new-line                                  value x"0a".

       linkage section.
      *     01  ls-rss-content-file-name              pic x(255).

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

      * TODO : Add actual implementation here. Below is a placeholder.

           display blank-screen 

           call "logger" using function concatenate(
               "Viewing feed item: ", ls-feed-item)
           end-call 

           accept rss-item-screen
           display blank-screen 

           goback.

       end program rss-reader-view-item.
