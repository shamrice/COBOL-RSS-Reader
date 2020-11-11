      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-07
      * Last Modified: 2020-11-11
      * Purpose: RSS Reader for parsed feeds.
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-menu.

       environment division.
       
       configuration section.

       input-output section.
           file-control.                              
               copy "./copybooks/filecontrol/rss_list_file.cpy".
               copy "./copybooks/filecontrol/rss_last_id_file.cpy".

       data division.
       file section.
           
           copy "./copybooks/filedescriptor/fd_rss_list_file.cpy".
           copy "./copybooks/filedescriptor/fd_rss_last_id_file.cpy".

       working-storage section.
       
       copy "screenio.cpy".
       copy "./copybooks/wsrecord/ws-rss-list-record.cpy".
       copy "./copybooks/wsrecord/ws-last-id-record.cpy".
       
       01 ws-func-key                          pic 9(4).
          88 func-f1                           value 1001.
          88 func-f2                           value 1002.
          88 func-f9                           value 1009.
          88 func-f10                          value 1010.

       01 ws-accept-func-key                   pic x.

       01 eof-sw                               pic a value 'N'.
           88 eof                              value 'Y'.
           88 not-eof                          value 'N'.     

       77 ws-selected-feed-file-name           pic x(255) value spaces.

       77 ws-counter                           pic 9(5) value 1.

       78 new-line                             value x"0a".
      
       78 ws-rss-list-file-name              value "./feeds/list.dat".
       78 ws-rss-last-id-file-name           value "./feeds/lastid.dat".

       
       screen section.

       copy "./screens/rss_list_screen.cpy".

       procedure division.
       main-procedure.
           display "In RSS reader."


           perform load-highest-rss-record

           perform display-current-feeds

           display "Calling view feed for debugging: "
           move "./feeds/rss_00002.dat" to ws-selected-feed-file-name
           call "rss-reader-view-feed" using by content                  
               ws-selected-feed-file-name
           end-call

      * Testing screen placeholders.
      *     display header-screen
      *     display main-function-screen
      *     accept main-function-screen
      *     display "Value entered: " ws-accept-func-key


           goback.



       load-highest-rss-record.
                      
           move 'N' to eof-sw

      * make sure file exists... 
           open extend rss-last-id-file close rss-last-id-file

           open input rss-last-id-file
               perform until eof
                   read rss-last-id-file into ws-last-id-record
                       at end move 'Y' to eof-sw                   
                   end-read
               end-perform
           close rss-last-id-file

           exit paragraph.


       display-current-feeds.

           display "Current Feeds: "   
      * make sure file exists... 
           open extend rss-list-file close rss-list-file

           open input rss-list-file
               
               perform until ws-counter > ws-last-id-record   
                   display "Checking RSS Feed ID: " ws-counter                       
                   move ws-counter to rss-feed-id
                   read rss-list-file into ws-rss-list-record
                       key is rss-feed-id
                       invalid key 
                           display "RSS Feed ID Not Found: " ws-counter
                       not invalid key 
                           display "RSS Feed ID: " ws-rss-feed-id
                           display "  Data file: " ws-rss-dat-file-name
                           display "   Feed URL: " ws-rss-link

                   end-read       
                   display spaces
                   add 1 to ws-counter                   
               end-perform
           close rss-list-file

           exit paragraph.           

       end program rss-reader-menu.
