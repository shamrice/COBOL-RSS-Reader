      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-07
      * Last Modified: 2021-01-04
      * Purpose: RSS Reader for parsed feeds.
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-menu.

       environment division.
       
       configuration section.

       repository.
           function rss-downloader.

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
           05  ws-display-rss-id               pic 9(5) value zeros. 
           05  ws-display-list-title           pic x(70) value spaces.
      
       01  refresh-items-sw                    pic a value 'Y'.
           88  is-refresh-items                value 'Y'.
           88  not-refresh-items               value 'N'.

       01  message-screen-fields.
           05  ws-msg-title                    pic x(70) value spaces.
           05  ws-msg-body                     occurs 2 times.
               10  ws-msg-body-text            pic x(70) value spaces.
           05  ws-msg-input                    pic x value space.
           
       77  rss-temp-filename                   pic x(255)
                                               value "./feeds/temp.rss".
       77  ws-selected-feed-file-name          pic x(255) value spaces.
       77  ws-selected-id                      pic 9(5) value zeros.

       77  ws-counter                          pic 9(5) value 1.
       77  ws-rss-idx                          pic 9(5) value 1.

       77  empty-line                          pic x(80) value spaces. 

       77  download-and-parse-status           pic 9 value zero.

       78  new-line                            value x"0a".
       
       77  ws-rss-content-file-name          pic x(255) value spaces.
       78  ws-rss-list-file-name             value "./feeds/list.dat".
       78  ws-rss-last-id-file-name          value "./feeds/lastid.dat".

       linkage section.

       01  ls-refresh-on-start                  pic a.
       
       screen section.

       copy "./screens/rss_list_screen.cpy".
       copy "./screens/blank_screen.cpy".
       copy "./screens/message_screen.cpy".

       procedure division using ls-refresh-on-start.
       set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
       set environment 'COB_SCREEN_ESC'        TO 'Y'.

       main-procedure.
           call "logger" using "In RSS reader."
      
      * Set switch to refresh items based on refresh parameter.
           move "Loading..." to ws-msg-title
           if ls-refresh-on-start = 'Y' then 
               move "Loading and refreshing RSS feeds..." 
                   to ws-msg-body-text(1)
               set is-refresh-items to true 
           else 
               move "Loading RSS feeds..." to ws-msg-body-text(1)
               set not-refresh-items to true 
           end-if
           display message-screen

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
                      compute ws-selected-id = 
                           ws-display-rss-id(cursor-line - 2)
                       end-compute
                       if ws-selected-id <= ws-last-id-record then

                           perform set-selected-feed-file-name

                           if ws-selected-feed-file-name 
                               not = spaces then
                               call "rss-reader-view-feed" using 
                                   by content ws-selected-feed-file-name
                               end-call
                               cancel "rss-reader-view-feed"
                           end-if
                       end-if

                   when crt-status = COB-SCR-F3
                       call "rss-reader-add-feed"
                       cancel "rss-reader-add-feed"
      *                Feed is refreshed if success in add sub program 
                       set not-refresh-items to true
                       perform set-rss-menu-items  


                   when crt-status = COB-SCR-F4
                       compute ws-selected-id = 
                           ws-display-rss-id(cursor-line - 2)
                       end-compute
                       if ws-selected-id <= ws-last-id-record then
                           call "rss-reader-delete-feed" using 
                               ws-selected-id
                           cancel "rss-reader-delete-feed"
      *                                     
                           set not-refresh-items to true 
     *                     perform set-rss-menu-items 
                       end-if                   
                        

                   when crt-status = COB-SCR-F5
                       
                       move "Loading and refreshing RSS feeds..." 
                           to ws-msg-body-text(1)
                       display message-screen

                       set is-refresh-items to true 
                       perform set-rss-menu-items  
      
                   when crt-status = COB-SCR-F10
                       set exit-true to true 
                   
               end-evaluate
    
           end-perform       

           display blank-screen    
           goback.


      * Called from set-rss-menu-items paragraph.
       load-highest-rss-record.
                      
           set not-eof to true 

      * make sure file exists... 
           open extend rss-last-id-file close rss-last-id-file

           open input rss-last-id-file
               perform until eof
                   read rss-last-id-file into ws-last-id-record
                       at end set eof to true                    
                   end-read
               end-perform
           close rss-last-id-file

           call "logger" using function concatenate(
               "Highest record found: ", ws-last-id-record)
           end-call 

           exit paragraph.



       set-rss-menu-items.

      * reset display items
           perform varying ws-counter from 1 by 1 until ws-counter > 17
               initialize ws-display-text(ws-counter)
           end-perform

           perform load-highest-rss-record

           if ws-last-id-record is zeros then 
               call "logger" using 
                   "No max RSS id found. No items to set. Skipping..."
               end-call 
               exit paragraph
           end-if 

      * Counter used to set idx of display line number. Only advances
      * on valid ws-rss-idx found.
           move 1 to ws-counter

      * make sure file exists... 
           open extend rss-list-file close rss-list-file

      * TODO : add paging offsets and real perform max value.

           open input rss-list-file

               perform varying ws-rss-idx 
                   from 1 by 1 until ws-rss-idx > ws-last-id-record

                   if ws-counter > 17 then 
                       call "logger" using function concatenate(
                           "Max feeds displayed on current page. Last",
                           "RSS idx: ", ws-last-id-record, 
                           " : line number: ", ws-counter, 
                           " :: done setting items.")
                       end-call 
                       close rss-list-file
                       exit paragraph
                   end-if 

                   call "logger" using function concatenate(
                       "Checking RSS Feed ID: ", ws-rss-idx)
                   end-call                      
                   move ws-rss-idx to rss-feed-id
                   read rss-list-file into ws-rss-list-record
                       key is rss-feed-id
                       invalid key 
                           call "logger" using function concatenate(
                               "Unable to find feed with id: ", 
                               rss-feed-id, " : Skipping.")
                           end-call 
                       not invalid key 
                           
                           call "logger" using function concatenate(
                               "FOUND :: Title=", ws-rss-title)
                           end-call                           
                       
                           move rss-feed-id 
                           to ws-display-rss-id(ws-counter)

                           move ws-rss-title
                           to ws-display-list-title(ws-counter)                           
                          
      *                Only refresh items if switch is set.                     
                           if is-refresh-items then 
                               call "logger" using function concatenate(
                                   "Refreshing feed: ", ws-rss-link)
                               end-call
      *      TODO : display error message to user on failure.                     
                               move function rss-downloader(ws-rss-link)
                                   to download-and-parse-status   

                               display message-screen                             
                           end-if
                           
                           add 1 to ws-counter 
                   end-read       
   
               end-perform

           close rss-list-file      
        
           call "logger" using "Done setting rss menu items"

           exit paragraph.


       set-selected-feed-file-name.

           if ws-selected-id > 0 then 
               call "logger" using function concatenate( 
                   "Getting file name for Feed ID: ", ws-selected-id)
               end-call
           else
               call "logger" using "Selected Id=0. No File name to set."
               move spaces to ws-selected-feed-file-name
               exit paragraph
           end-if                      
               
           open input rss-list-file
               
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
