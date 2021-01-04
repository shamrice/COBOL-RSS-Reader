      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-03
      * Last Modified: 2021-01-04
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

       01  ls-rss-link                         pic x(256).

       01  ls-delete-feed-status               pic 9 value zero.

       screen section.    
   
       procedure division 
           using ls-rss-link 
           returning ls-delete-feed-status.
      
       main-procedure.

           if ls-rss-link = spaces then 
               call "logger" using function concatenate(
                   "URL is required to delete an RSS feed. No URL ",
                   "passed to remove-rss-record. Returning status 2.")
               end-call
               move 2 to ls-delete-feed-status
               goback 
           end-if

           move ls-rss-link to rss-link   

           perform delete-rss-record
           
           goback.

       
       delete-rss-record.

           call "logger" using function concatenate(
               "Deleting RSS with URL: " rss-link)
           end-call 

           open i-o rss-list-file

               delete rss-list-file record
                   invalid key
                       call "logger" using function concatenate( 
                           "No RSS record to delete with url: " 
                           rss-link, " : No record found.") 
                       end-call 
                       move 3 to ls-delete-feed-status
                       
                   not invalid key
                       call "logger" using function concatenate( 
                           "RSS Record id " rss-feed-id " deleted.") 
                       end-call 
                       move 1 to ls-delete-feed-status
               end-delete

           close rss-list-file

           exit paragraph.

       end function remove-rss-record.
