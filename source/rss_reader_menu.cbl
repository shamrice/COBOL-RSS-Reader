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

      *   The SPECIAL-NAMES paragraph that follows provides for the 
      *   capturing of the F10 function key and for positioning of the 
      *   cursor.        
       special-names.
 
           symbolic characters
               fkey-10-val are 11         
           cursor is cursor-position        
           crt status is crt-status.

       input-output section.
           file-control.                              
               copy "./copybooks/filecontrol/rss_list_file.cpy".
               copy "./copybooks/filecontrol/rss_last_id_file.cpy".
               copy "./copybooks/filecontrol/rss_content_file.cpy".

       data division.
       file section.
           
           copy "./copybooks/filedescriptor/fd_rss_list_file.cpy".
           copy "./copybooks/filedescriptor/fd_rss_last_id_file.cpy".
           copy "./copybooks/filedescriptor/fd_rss_content_file.cpy".

       working-storage section.
       
       copy "screenio.cpy".
       copy "./copybooks/wsrecord/ws-rss-list-record.cpy".
       copy "./copybooks/wsrecord/ws-last-id-record.cpy".
       copy "./copybooks/wsrecord/ws-rss-record.cpy".

      *   CURSOR-LINE specifies the line and CURSOR-COL specifies the 
      *   column of the cursor position.            
       01  cursor-position. 
           05  cursor-line    pic 99. 
           05  cursor-col     pic 99. 
        
      *   Normal termination of the ACCEPT statement will result in a value 
      *   of '0' in KEY1.  When the user presses F10, the value in KEY1 will 
      *   be '1' and FKEY-10 will be true.         
       01  crt-status. 
           05  key1             pic x. 
           05  key2             pic x. 
               88  fkey-10      value fkey-10-val. 
           05  filler           pic x. 
           05  filler           pic x.
        

       01  ws-func-key                          pic 9(4).
           88  func-f1                           value 1001.
           88  func-f2                           value 1002.
           88  func-f9                           value 1009.
           88  func-f10                          value 1010.

       01  ws-accept-func-key                   pic x.

       01  accept-item1                         pic x value space.

       01  eof-sw                               pic a value 'N'.
           88  eof                              value 'Y'.
           88  not-eof                          value 'N'.     

      * String to display on menu screen.
       01  ws-display-text                     occurs 17 times. 
           05  ws-display-list-title           pic x(20) value spaces.
           05  ws-display-list-url             pic x(50) value spaces.

       77  ws-selected-feed-file-name           pic x(255) value spaces.

       77  ws-counter                           pic 9(5) value 1.

       77  empty-line                           pic x(80). 

       78  new-line                             value x"0a".
       
       77  ws-rss-content-file-name     pic x(255) value spaces.
       78  ws-rss-list-file-name             value "./feeds/list.dat".
       78  ws-rss-last-id-file-name          value "./feeds/lastid.dat".

       
       screen section.

       copy "./screens/rss_list_screen.cpy".

       procedure division.
       main-procedure.
           display "In RSS reader."

           

           perform load-highest-rss-record 
           perform set-rss-menu-items  
  
      *     display "Calling view feed for debugging: "
      *     move "./feeds/rss_00001.dat" to ws-selected-feed-file-name
           
      *     call "rss-reader-view-feed" using by content                  
      *         ws-selected-feed-file-name
      *     end-call

           display "done loading rss menu items." 

           display "disp text= " ws-display-text(1)  

      *     display rss-list-screen
        
      *   The cursor position is not within an item on the screen, so the 
      *   first item in the menu will be accepted first. 
                   
           move 0 to cursor-line, cursor-col. 
           
      *   The user moves the cursor with the arrow keys to the 
      *   desired menu item (to show, schedule, cancel, or print 
      *   appointments) and selects the item by pressing <Return>. 
      *   If the user wishes to exit without selecting an option, 
      *   the user can press the F10 function key. 
        
           accept rss-list-screen            
        
           display "key1=" key1
        
           if key1 equal 0 then
               display "chosen an option: " cursor-line
 
           else 
               if key1 equal "1" and fkey-10 then
                   display 
                       "You pressed the F10 key; exiting..." 
                       line 22
                   end-display
               end-if
           end-if
                
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


       set-rss-menu-items.

      * make sure file exists... 
           open extend rss-list-file close rss-list-file

      * TODO : add paging offsets and real perform max value.
           move 1 to ws-counter

           open input rss-list-file
               perform until ws-counter > ws-last-id-record 
                             or ws-counter > 17
                                                                 
                   display "Checking RSS Feed ID: " ws-counter                       
                   move ws-counter to rss-feed-id
                   read rss-list-file into ws-rss-list-record
                       key is rss-feed-id
                       invalid key 
                           move spaces 
                           to ws-display-text(ws-counter)

                       not invalid key 
                           
                           display "FOUND: " ws-rss-list-record
                           display "title=" ws-rss-title                           
                       
                           move ws-rss-title
                           to ws-display-list-title(ws-counter)                           

                           move ws-rss-link
                           to ws-display-list-url(ws-counter)                           

                           display 
                               "disp=" 
                               ws-display-text(ws-counter) 
                           end-display
                     
                   end-read       
                   display spaces
                   add 1 to ws-counter                                  
   
               end-perform
           close rss-list-file      
        
           display "Done setting rss menu items"

           exit paragraph.


       display-current-feeds.

           display "Current Feeds: "   
      * make sure file exists... 
           open extend rss-list-file close rss-list-file

           move 1 to ws-counter

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
                           display " Feed Title: " ws-rss-title
                           display "  Data file: " ws-rss-dat-file-name
                           display "   Feed URL: " ws-rss-link

                   end-read       
                   display spaces
                   add 1 to ws-counter                   
               end-perform
           close rss-list-file

           exit paragraph.           

       end program rss-reader-menu.
