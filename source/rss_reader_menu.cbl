      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-07
      * Last Modified: 2021-10-05
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
           cursor is ws-cursor-position        
           crt status is ws-crt-status.

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
       01  ws-cursor-position. 
           05  ws-cursor-line                   pic 99. 
           05  ws-cursor-col                    pic 99. 
        
      *   CRT status has four digit value of what key was pressed.  
      *   screenio.cpy has values in form of COB-SCR-<KEY> defined. 
       01  ws-crt-status. 
           05  ws-key1                          pic x. 
           05  ws-key2                          pic x. 
           05  filler                           pic x. 
           05  filler                           pic x.

       01  ws-mouse-flags                       pic 9(4).       

      * Input from screen accept.  
       01  accept-item1                         pic x value space.

       01  ws-eof-sw                            pic a value 'N'.
           88  ws-eof                           value 'Y'.
           88  ws-not-eof                       value 'N'.     

       01  ws-exit-sw                           pic a value 'N'.
           88  ws-exit-true                     value 'Y'.
           88  ws-exit-false                    value 'N'.

      * String to display on menu screen.
       01  ws-display-text                     occurs 17 times.           
           05  ws-display-rss-id               pic 9(5) value zeros. 
           05  ws-display-list-title           pic x(70) value spaces.
           05  ws-display-text-color           pic 9 
                                               value cob-color-white.
      
       01  ws-refresh-items-sw                 pic a value 'Y'.
           88  ws-is-refresh-items             value 'Y'.
           88  ws-not-refresh-items            value 'N'.

       01  ws-message-screen-fields.
           05  ws-msg-title                    pic x(70) value spaces.
           05  ws-msg-body                     occurs 2 times.
               10  ws-msg-body-text            pic x(70) value spaces.
           05  ws-msg-input                    pic x value space.
           
       77  ws-selected-feed-file-name          pic x(255) value spaces.
       77  ws-selected-id                      pic 9(5) value zeros.

       77  ws-counter                          pic 9(5) value 1.
       77  ws-rss-idx                          pic 9(5) value 1.

       77  ws-empty-line                       pic x(80) value spaces. 

       77  ws-download-and-parse-status        pic 9 value zero.

      
       77  ws-rss-content-file-name          pic x(255) value spaces.
       78  ws-rss-list-file-name             value "./feeds/list.dat".
       78  ws-rss-last-id-file-name          value "./feeds/lastid.dat".

       78  ws-feed-status-success            value 1.

       linkage section.

       01  l-refresh-on-start                  pic a.
       
       screen section.

       copy "./screens/rss_list_screen.cpy".
       copy "./screens/blank_screen.cpy".
       copy "./screens/message_screen.cpy".


       procedure division using l-refresh-on-start.
           set environment 'COB_SCREEN_EXCEPTIONS' to 'Y'.
           set environment 'COB_SCREEN_ESC'        to 'Y'.
           set environment "COB_EXIT_WAIT"         to "NO".
           

       mouse-setup.
           compute ws-mouse-flags = COB-AUTO-MOUSE-HANDLING 
               + COB-ALLOW-LEFT-DOWN
               + COB-ALLOW-LEFT-UP
               + COB-ALLOW-MOUSE-MOVE

           set environment "COB_MOUSE_FLAGS" to ws-mouse-flags.

       main-procedure.
           call "logger" using "In RSS reader."
      
      * Set switch to refresh items based on refresh parameter.
           move "Loading..." to ws-msg-title
           if l-refresh-on-start = 'Y' then 
               move "Loading and refreshing RSS feeds..." 
                   to ws-msg-body-text(1)
               set ws-is-refresh-items to true 
           else 
               move "Loading RSS feeds..." to ws-msg-body-text(1)
               set ws-not-refresh-items to true 
           end-if
           display s-message-screen

      * Load and set RSS feeds into feed menu records 
           perform set-rss-menu-items  

           call "logger" using "done loading rss menu items." 
       
      *   The cursor position is not within an item on the screen, so the 
      *   first item in the menu will be accepted first. 
           move 0 to ws-cursor-line, ws-cursor-col              

           perform until ws-exit-true
                                  
               move 0 to ws-selected-id
               move spaces to ws-crt-status
               move spaces to ws-selected-feed-file-name
               
               display s-blank-screen        
               accept s-rss-list-screen
        
               evaluate true 
               
                   when ws-key1 = COB-SCR-OK
                      perform open-selected-in-reader-view-feed

                   when ws-crt-status = COB-SCR-F1
                       perform open-help

                   when ws-crt-status = COB-SCR-F3
                       perform open-add-feed 

                   when ws-crt-status = COB-SCR-F4
                       compute ws-selected-id = 
                           ws-display-rss-id(ws-cursor-line - 2)
                       end-compute
                       perform open-delete-feed
                        
                   when ws-crt-status = COB-SCR-F5
                       perform refresh-feeds                       

                   when ws-crt-status = COB-SCR-F8
                       compute ws-selected-id = 
                           ws-display-rss-id(ws-cursor-line - 2)
                       end-compute
                       perform open-export-feed  

                   when ws-crt-status = COB-SCR-F9
                       perform open-configuration            
                        
                   when ws-crt-status = COB-SCR-F10
                       set ws-exit-true to true 
      
      *>   Mouse input handling.                   
                   when ws-crt-status = COB-SCR-LEFT-RELEASED
                       perform handle-mouse-click                   

               end-evaluate
    
           end-perform       

           display s-blank-screen    
           goback.


       handle-mouse-click.
           call "logger" using function concatenate(
               "Mouse clicked at: ", ws-cursor-position)
           end-call 
           
           if ws-cursor-line = 21 then 
               
               evaluate true 
               
                   when ws-cursor-col >= 2 and ws-cursor-col < 9 
                       perform open-help
                   

                   when ws-cursor-col >= 10 and ws-cursor-col < 21
                       perform open-add-feed

                   when ws-cursor-col >= 22 and ws-cursor-col < 36                       
                       display "Enter RSS feed id to delete: " 
                           with blank line 
                           at 2101
                       end-display 
                       accept ws-selected-id at 2130

                       call "logger" using function concatenate(
                           "selected id from delete set: " 
                           ws-selected-id)
                       end-call
                       perform open-delete-feed

                   when ws-cursor-col >= 37 and ws-cursor-col < 47
                       perform refresh-feeds

                   when ws-cursor-col >= 48 and ws-cursor-col < 57                       
                       display "Enter RSS feed id to export: "                            
                           with blank line 
                           at 2101
                       end-display 
                       accept ws-selected-id at 2130

                       call "logger" using function concatenate(
                           "selected id for export set: " 
                           ws-selected-id)
                       end-call                       
                       perform open-export-feed

                   when ws-cursor-col >= 58 and ws-cursor-col < 68
                       perform open-configuration

                   when ws-cursor-col >= 69 and ws-cursor-col < 76 
                       set ws-exit-true to true 

               end-evaluate
           end-if 
           if ws-cursor-line < 20 then 
               perform open-selected-in-reader-view-feed
           end-if 

           exit paragraph.


       open-help.
           call "rss-reader-help"
           cancel "rss-reader-help"
           exit paragraph.


       open-add-feed.
           call "rss-reader-add-feed"
           cancel "rss-reader-add-feed"
      *>   Feed is refreshed if success in add sub program 
           set ws-not-refresh-items to true
           perform set-rss-menu-items        

           exit paragraph.



       open-delete-feed.
      *>   selected id set by key or mouse input handler before calling
      *>   this paragraph.     
           if ws-selected-id <= ws-last-id-record then
               call "rss-reader-delete-feed" using ws-selected-id
               cancel "rss-reader-delete-feed"                                                          
               set ws-not-refresh-items to true 
               perform set-rss-menu-items
           end-if  
                      
           exit paragraph.
          

       refresh-feeds.
           move "Loading and refreshing RSS feeds..." 
               to ws-msg-body-text(1)
           display s-message-screen

           set ws-is-refresh-items to true 
           perform set-rss-menu-items         

           exit paragraph.


       open-export-feed.
      *>   selected id set by key or mouse input handler before calling
      *>   this paragraph.     
           if ws-selected-id <= ws-last-id-record then
               call "rss-reader-export-feed" using ws-selected-id
               cancel "rss-reader-export-feed"
                                           
               set ws-not-refresh-items to true 
               perform set-rss-menu-items 
           end-if            
           exit paragraph.


       open-configuration.
           call "rss-reader-configuration"
           cancel "rss-reader-configuration"
           exit paragraph.

       open-selected-in-reader-view-feed.
           compute ws-selected-id = 
               ws-display-rss-id(ws-cursor-line - 2)
           end-compute
           if ws-selected-id <= ws-last-id-record then

               perform set-selected-feed-file-name

               if ws-selected-feed-file-name not = spaces then
                   call "rss-reader-view-feed" using 
                       by content ws-selected-feed-file-name
                   end-call
                   cancel "rss-reader-view-feed"
               end-if
           end-if  

           exit paragraph.


      * Called from set-rss-menu-items paragraph.
       load-highest-rss-record.
                      
           set ws-not-eof to true 

      * make sure file exists... 
           open extend fd-rss-last-id-file close fd-rss-last-id-file

           open input fd-rss-last-id-file
               perform until ws-eof
                   read fd-rss-last-id-file into ws-last-id-record
                       at end set ws-eof to true                    
                   end-read
               end-perform
           close fd-rss-last-id-file

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
           open extend fd-rss-list-file close fd-rss-list-file

      * TODO : add paging offsets and real perform max value.

           open input fd-rss-list-file

               perform varying ws-rss-idx 
                   from 1 by 1 until ws-rss-idx > ws-last-id-record

                   if ws-counter > 17 then 
                       call "logger" using function concatenate(
                           "Max feeds displayed on current page. Last",
                           "RSS idx: ", ws-last-id-record, 
                           " : line number: ", ws-counter, 
                           " :: done setting items.")
                       end-call 
                       close fd-rss-list-file
                       exit paragraph
                   end-if 

                   call "logger" using function concatenate(
                       "Checking RSS Feed ID: ", ws-rss-idx)
                   end-call                      
                   move ws-rss-idx to f-rss-feed-id
                   read fd-rss-list-file into ws-rss-list-record
                       key is f-rss-feed-id
                       invalid key 
                           call "logger" using function concatenate(
                               "Unable to find feed with id: ", 
                               f-rss-feed-id, " : Skipping.")
                           end-call 
                       not invalid key 
                           
                           call "logger" using function concatenate(
                               "FOUND :: Title=", ws-rss-title)
                           end-call                           
                       
                           move f-rss-feed-id 
                           to ws-display-rss-id(ws-counter)

                           move ws-rss-title
                           to ws-display-list-title(ws-counter)    

                           move f-rss-feed-status 
                               to ws-download-and-parse-status                       
                          
      *                Only refresh items if switch is set.                     
                           if ws-is-refresh-items then 
                               call "logger" using function concatenate(
                                   "Refreshing feed: ", ws-rss-link)
                               end-call
      *      TODO : display error message to user on failure.                     
                               move function rss-downloader(ws-rss-link)
                                   to ws-download-and-parse-status   

                               display s-message-screen                             
                           end-if

                           *> Set text color based on feed status
                           if ws-download-and-parse-status 
                           = ws-feed-status-success then                                
                               move cob-color-white
                               to ws-display-text-color(ws-counter)
                           else 
                               move cob-color-red
                               to ws-display-text-color(ws-counter)
                           end-if
                           
                           add 1 to ws-counter 
                   end-read       
   
               end-perform

           close fd-rss-list-file      
        
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
               
           open input fd-rss-list-file
               
               move ws-selected-id to f-rss-feed-id
               read fd-rss-list-file into ws-rss-list-record
                   key is f-rss-feed-id
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

           close fd-rss-list-file 

           exit paragraph.

       end program rss-reader-menu.
