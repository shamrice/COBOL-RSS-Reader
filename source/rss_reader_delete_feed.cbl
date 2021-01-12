      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-03
      * Last Modified: 2021-01-12
      * Purpose: RSS Reader Delete Feed - Screen sub program to delete 
      *          selected feed.
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-delete-feed.

       environment division.
       
       configuration section.

       repository.
           function remove-rss-record.

       special-names.
           crt status is ws-crt-status.

       input-output section.
           file-control.                              
               copy "./copybooks/filecontrol/rss_list_file.cpy".

       data division.
       file section.
           copy "./copybooks/filedescriptor/fd_rss_list_file.cpy".

       working-storage section.

       copy "screenio.cpy".
       copy "./copybooks/wsrecord/ws-rss-list-record.cpy".

       01  ws-crt-status. 
           05  ws-key1                       pic x. 
           05  ws-key2                       pic x. 
           05  filler                        pic x. 
           05  filler                        pic x.

       01  ws-accept                         pic x value zero.

       01  ws-delete-feed-status             pic 9 value zero.

       01  ws-delete-msg.
           05  ws-delete-line-1              pic x(70) value spaces.
           05  ws-delete-line-2              pic x(70) value spaces.

       01  ws-message-screen-fields.
           05  ws-msg-title                  pic x(70) value spaces.
           05  ws-msg-body                   occurs 2 times.
               10  ws-msg-body-text          pic x(70) value spaces.
           05  ws-msg-input                  pic x value space.
         
       01  ws-exit-sw                        pic a value 'N'.
           88  ws-exit-true                  value 'Y'.
           88  ws-exit-false                 value 'N'.

       77  ws-empty-line                     pic x(80) value spaces. 

       78  ws-rss-list-file-name             value "./feeds/list.dat".

       linkage section.

       01  l-rss-feed-id                     pic 9(5).

       screen section.
       
       copy "./screens/blank_screen.cpy".
       copy "./screens/rss_delete_feed_screen.cpy".
       copy "./screens/message_screen.cpy".

       procedure division using l-rss-feed-id.
       set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
       set environment 'COB_SCREEN_ESC'        TO 'Y'.
      
       main-procedure.

           if l-rss-feed-id is zeros then 
               call "logger" using function concatenate(
                   "Cannot delete RSS feed with ID ", l-rss-feed-id,
                   ". Ignoring delete request and returning.")
               end-call
               goback 
           end-if

           move "Delete Feed Status" to ws-msg-title
           
           move l-rss-feed-id to f-rss-feed-id   

           perform load-feed-to-delete

           move function concatenate("Delete feed ", 
               function trim(ws-rss-title), 
               " from feed list?") to ws-delete-msg

           perform handle-user-input

           display s-blank-screen 
           goback.


       handle-user-input.

           perform until ws-exit-true

               accept s-rss-delete-feed-screen 

               evaluate true 
                      
                   when ws-key1 = COB-SCR-OK
                       call "logger" using l-rss-feed-id
                       perform delete-rss-record
                       accept s-message-screen
                       set ws-exit-true to true 
                    
                   when ws-crt-status = COB-SCR-ESC
                       set ws-exit-true to true
                       
               end-evaluate
           end-perform

           exit paragraph.


       load-feed-to-delete.
          
           open input fd-rss-list-file

               read fd-rss-list-file into ws-rss-list-record
               key is f-rss-feed-id
                   invalid key 
                       call "logger" using function concatenate( 
                           "Delete RSS feed: Unable to load feed by ",
                           "rss list id. Invalid key: ", f-rss-feed-id)
                       end-call

                   not invalid key                            
                       call "logger" using function concatenate( 
                           "Found to delete :: ID: ", f-rss-feed-id, 
                           " :: Title: ", ws-rss-title)
                       end-call     
                  
               end-read       
           close fd-rss-list-file      
           
           exit paragraph.

       
       delete-rss-record.

           call "logger" using function concatenate(
               "Deleting RSS id: ", f-rss-feed-id)
           end-call 

           move function remove-rss-record(f-rss-link) 
               to ws-delete-feed-status

           if ws-delete-feed-status = 1 then 
               call "logger" using function concatenate( 
                   "RSS Record " f-rss-feed-id " deleted.") 
               end-call 
               move "Successfully deleted RSS Feed from list."
                   to ws-msg-body-text(1)
           else
               move "Unable to delete RSS feed from list."
                   to ws-msg-body-text(1)
               move function concatenate(
                   "Delete status code: ", ws-delete-feed-status)
                   to ws-msg-body-text(2)
           end-if

           exit paragraph.

       end program rss-reader-delete-feed.
