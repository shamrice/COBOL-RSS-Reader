      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-07
      * Last Modified: 2020-12-28
      * Purpose: RSS Reader for parsed feeds.
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-menu.

       environment division.
       
       configuration section.

      *   The SPECIAL-NAMES paragraph that follows provides for the 
      *   capturing of the positioning of the cursor and key input.        
       special-names.
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
        
      *   CRT status has four digit value of what key was pressed.  
      *   screenio.cpy has values in form of COB-SCR-<KEY> defined. 
       01  crt-status. 
           05  key1             pic x. 
           05  key2             pic x. 
           05  filler           pic x. 
           05  filler           pic x.

      * Input from screen accept.  
       01  accept-item1                         pic x value space.

       01  eof-sw                               pic a value 'N'.
           88  eof                              value 'Y'.
           88  not-eof                          value 'N'.     

       01  exit-sw                              pic a value 'N'.
           88  exit-true                        value 'Y'.
           88  exit-false                       value 'N'.

      * String to display on menu screen.
       01  ws-display-text                     occurs 17 times. 
           05  ws-display-list-title           pic x(20) value spaces.
           05  ws-display-list-url             pic x(50) value spaces.

       01  refresh-items-sw                    pic a value 'Y'.
           88  is-refresh-items                value 'Y'.
           88  not-refresh-items               value 'N'.

       77 rss-temp-filename                    pic x(255)
                                               value "./feeds/temp.rss".

       77  ws-selected-feed-file-name           pic x(255) value spaces.
       77  ws-selected-id                       pic 9(5) value zeros.

       77  ws-counter                           pic 9(5) value 1.

       77  ws-loading-msg                       pic x(70) value spaces.
       77  empty-line                           pic x(80) value spaces. 

       78  new-line                             value x"0a".
       
       77  ws-rss-content-file-name          pic x(255) value spaces.
       78  ws-rss-list-file-name             value "./feeds/list.dat".
       78  ws-rss-last-id-file-name          value "./feeds/lastid.dat".

       linkage section.

       01  ls-refresh-on-start                  pic a.
       
       screen section.

       copy "./screens/rss_list_screen.cpy".
       copy "./screens/blank_screen.cpy".
       copy "./screens/loading_screen.cpy".

       procedure division using ls-refresh-on-start.

       main-procedure.
           call "logger" using "In RSS reader."
      
      * Set switch to refresh items based on refresh parameter.
           if ls-refresh-on-start = 'Y' then 
               move "Loading and refreshing RSS feeds..." 
                   to ws-loading-msg
               move 'Y' to refresh-items-sw
           else 
               move "Loading RSS feeds..." to ws-loading-msg
               move 'N' to refresh-items-sw
           end-if
           display loading-screen

      * Load and set RSS feeds into feed menu records 
           perform set-rss-menu-items  

           call "logger" using "done loading rss menu items." 
       
      *   The cursor position is not within an item on the screen, so the 
      *   first item in the menu will be accepted first. 
           move 0 to cursor-line, cursor-col              

           perform until exit-true
                                  
               move 0 to ws-selected-id
               move spaces to crt-status
               move spaces to ws-selected-feed-file-name
                   
               accept rss-list-screen
        
               evaluate true 
               
                   when key1 = COB-SCR-OK
                      compute ws-selected-id = cursor-line - 2
                       if ws-selected-id <= ws-last-id-record then

                           perform set-selected-feed-file-name

                           call "rss-reader-view-feed" using by content                  
                               ws-selected-feed-file-name
                           end-call
                           cancel "rss-reader-view-feed"
                       end-if

                   when crt-status = COB-SCR-F5
                       
                       move "Loading and refreshing RSS feeds..." 
                           to ws-loading-msg
                       display loading-screen

                       move 'Y' to refresh-items-sw
                       perform set-rss-menu-items  
      
                   when crt-status = COB-SCR-F10
                       display 
                           "Exiting...                 " 
                           line 23 column 30
                       end-display
                       move 'Y' to exit-sw
                   
               end-evaluate
    
           end-perform       

           display blank-screen    
           goback.


      * Called from set-rss-menu-items paragraph.
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

           perform load-highest-rss-record

      * make sure file exists... 
           open extend rss-list-file close rss-list-file

      * TODO : add paging offsets and real perform max value.
           move 1 to ws-counter

           open input rss-list-file
               perform until ws-counter > ws-last-id-record 
                             or ws-counter > 17
                                                                 
                   call "logger" using function concatenate(
                       "Checking RSS Feed ID: ", ws-counter)
                   end-call                      
                   move ws-counter to rss-feed-id
                   read rss-list-file into ws-rss-list-record
                       key is rss-feed-id
                       invalid key 
                           move spaces 
                           to ws-display-text(ws-counter)

                       not invalid key 
                           
                           call "logger" using function concatenate( 
                               "FOUND: ", ws-rss-list-record)
                           end-call
                           call "logger" using function concatenate(
                               "title=", ws-rss-title)
                           end-call                           
                       
                           move ws-rss-title
                           to ws-display-list-title(ws-counter)                           

                           move ws-rss-link
                           to ws-display-list-url(ws-counter)                           

                           call "logger" using function concatenate( 
                               "disp=",
                               ws-display-text(ws-counter))
                           end-call
                           
      *                Only refresh items if switch is set.                     
                           if is-refresh-items then 
                               call "logger" using function concatenate(
                                   "Refreshing feed: ", ws-rss-link)
                               end-call
                           
                               call "rss-downloader" using by content 
                                   ws-rss-link 
                               end-call
                           end-if
                   
                   end-read       
                  
                   add 1 to ws-counter                                  
   
               end-perform

           close rss-list-file      
        
           call "logger" using "Done setting rss menu items"

           exit paragraph.


       set-selected-feed-file-name.
           open input rss-list-file
               call "logger" using function concatenate( 
                   "Getting file name for Feed ID: ", ws-counter)
               end-call                      
               
               move ws-selected-id to rss-feed-id
               read rss-list-file into ws-rss-list-record
                   key is rss-feed-id
                   invalid key 
                       move spaces 
                       to ws-selected-feed-file-name

                   not invalid key 
                           
                       call "logger" using function concatenate(
                           "FOUND: ", ws-rss-dat-file-name)
                       end-call                           
                   
                       move ws-rss-dat-file-name
                       to ws-selected-feed-file-name                             
               
               end-read       

           close rss-list-file 

           exit paragraph.

       end program rss-reader-menu.
