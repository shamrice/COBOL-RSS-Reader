      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-03
      * Last Modified: 2021-01-03
      * Purpose: RSS Reader Delete Feed - Screen sub program to delete 
      *          selected feed.
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-delete-feed.

       environment division.
       
       configuration section.

       repository.
           function rss-downloader.

       special-names.
           crt status is crt-status.

       input-output section.
           file-control.                              
               copy "./copybooks/filecontrol/rss_list_file.cpy".

       data division.
       file section.
           copy "./copybooks/filedescriptor/fd_rss_list_file.cpy".

       working-storage section.

       copy "screenio.cpy".
       copy "./copybooks/wsrecord/ws-rss-list-record.cpy".

       01  crt-status. 
           05  key1                          pic x. 
           05  key2                          pic x. 
           05  filler                        pic x. 
           05  filler                        pic x.

       01  ws-accept                         pic x value zero.

       01  ws-delete-feed-status                pic 9 value zero.

       01  message-screen-fields.
           05  ws-msg-title                    pic x(70) value spaces.
           05  ws-msg-body                     occurs 2 times.
               10  ws-msg-body-text            pic x(70) value spaces.
           05  ws-msg-input                    pic x value space.
         
       01  exit-sw                           pic a value 'N'.
           88  exit-true                     value 'Y'.
           88  exit-false                    value 'N'.

       01  ws-rss-id                         pic 9(5) value zeros.

       77  empty-line                        pic x(80) value spaces. 

       78  new-line                          value x"0a".
       78  ws-rss-list-file-name             value "./feeds/list.dat".

       linkage section.

       01  ls-rss-feed-id              pic 9(5).

       screen section.
       
       copy "./screens/blank_screen.cpy".
       copy "./screens/rss_delete_feed_screen.cpy".
       copy "./screens/message_screen.cpy".

       procedure division using ls-rss-feed-id.
       set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
       set environment 'COB_SCREEN_ESC'        TO 'Y'.
      
       main-procedure.

           move "Delete Feed Status" to ws-msg-title
           move ls-rss-feed-id to ws-rss-id        
           perform load-feed-to-delete

           perform handle-user-input

           display blank-screen 
           goback.


       handle-user-input.

           perform until exit-true

               accept rss-delete-feed-screen 

               evaluate true 
                      
                   when key1 = COB-SCR-OK
                       call "logger" using ls-rss-feed-id


                       accept message-screen
                       move 'Y' to exit-sw
                    
                   when crt-status = COB-SCR-ESC
                       move 'Y' to exit-sw
                       
               end-evaluate
           end-perform

           exit paragraph.


       load-feed-to-delete.

      * TODO: Always returns invalid key... not sure why.

           open input rss-list-file

               read rss-list-file into ws-rss-list-record
               key is ws-rss-id
                   invalid key 
                       call "logger" using function concatenate( 
                           "Delete RSS feed: Unable to load feed by ",
                           "rss list id. Invalid key: ", ws-rss-id)
                       end-call

                   not invalid key 
                           
                       call "logger" using function concatenate( 
                           "FOUND: ", ws-rss-list-record)
                       end-call
                       call "logger" using function concatenate(
                           "title=", ws-rss-title)
                       end-call                           
               end-read       
           close rss-list-file      
           
           exit paragraph.

       end program rss-reader-delete-feed.
