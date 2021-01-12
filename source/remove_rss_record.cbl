      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-03
      * Last Modified: 2021-01-12
      * Purpose: Deletes RSS record based on RSS url passed
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       function-id. remove-rss-record.

       environment division.
       
       configuration section.

       repository.

       special-names.

       input-output section.
           file-control.                              
               copy "./copybooks/filecontrol/rss_list_file.cpy".

       data division.
       file section.
           copy "./copybooks/filedescriptor/fd_rss_list_file.cpy".

       working-storage section.

       copy "./copybooks/wsrecord/ws-rss-list-record.cpy".

       78  ws-rss-list-file-name               value "./feeds/list.dat".

       linkage section.

       01  l-rss-link                          pic x(256).
 
       01  l-delete-feed-status                pic 9 value zero.
           88  l-return-status-success           value 1.
           88  l-return-status-bad-param         value 2.
           88  l-return-status-not-found         value 3.

       screen section.    
   
       procedure division 
           using l-rss-link 
           returning l-delete-feed-status.
      
       main-procedure.

           if l-rss-link = spaces then 
               call "logger" using function concatenate(
                   "URL is required to delete an RSS feed. No URL ",
                   "passed to remove-rss-record. Returning status 2.")
               end-call
               set l-return-status-bad-param to true 
               goback 
           end-if

           move l-rss-link to f-rss-link   

           perform delete-rss-record
           
           goback.

       
       delete-rss-record.

           call "logger" using function concatenate(
               "Deleting RSS with URL: ", f-rss-link)
           end-call 

           open i-o fd-rss-list-file

               delete fd-rss-list-file record
                   invalid key
                       call "logger" using function concatenate( 
                           "No RSS record to delete with url: ", 
                           f-rss-link, " : No record found.") 
                       end-call
                       set l-return-status-not-found to true 
                       
                   not invalid key
                       call "logger" using function concatenate( 
                           "RSS Record id ", f-rss-feed-id, " deleted.") 
                       end-call 
                       set l-return-status-success to true 
               end-delete

           close fd-rss-list-file

           exit paragraph.

       end function remove-rss-record.
