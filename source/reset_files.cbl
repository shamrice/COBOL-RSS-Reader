      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2021-02-04
      *> Last Updated: 2021-09-29
      *> Purpose: Deletes all feed related data files.
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************
       replace ==:BUFFER-SIZE:== by ==32768==.

       identification division.
       program-id. reset-files.

       environment division.
       
       configuration section.

       repository.

       special-names.

       input-output section.

           file-control.                              
               select optional fd-rss-last-id-file
               assign to dynamic ws-rss-last-id-file-name
               organization is line sequential
               status is ws-last-id-file-status.

               select fd-rss-list-file 
               assign to dynamic ws-rss-list-file-name
               organization is indexed
               access is dynamic
               record key is f-rss-link
               alternate record key is f-rss-feed-id
               status is ws-list-file-status.

               select fd-rss-content-file 
               assign to dynamic ws-rss-dat-file-name
               status is ws-dat-file-status.

               select fd-temp-rss-file
               assign to dynamic ws-rss-working-temp-file-name
               organization is line sequential
               status is ws-temp-file-status.

       data division.
       file section.
           copy "./copybooks/filedescriptor/fd_rss_list_file.cpy".
           copy "./copybooks/filedescriptor/fd_rss_last_id_file.cpy".
           copy "./copybooks/filedescriptor/fd_rss_content_file.cpy".

           FD fd-temp-rss-file.
           01 f-temp-rss-file-raw                 pic x(:BUFFER-SIZE:).

       working-storage section.
 
       copy "./copybooks/wsrecord/ws-last-id-record.cpy".
       
       01  ws-file-status.
           05  ws-last-id-file-status        pic 99.
           05  ws-list-file-status           pic 99.
           05  ws-dat-file-status            pic 99.
           05  ws-temp-file-status           pic 99.

       01  ws-counter                        pic 9(5).

       01  ws-accept-delete                  pic a.

       01  ws-eof-sw                         pic a value 'N'.
           88  ws-eof                        value 'Y'.
           88  ws-not-eof                    value 'N'.     

       01  ws-rss-dat-file-name              pic x(128) value spaces.

       78  ws-rss-last-id-file-name          value "./feeds/lastid.dat".
       78  ws-rss-list-file-name             value "./feeds/list.dat".
       
       01  ws-rss-working-temp-file-name     pic x(128).
       
       78  ws-rss-temp-file-name             value "./feeds/temp.rss".
       
       78  ws-rss-temp-retry-file-name       value "./feeds/temp1.rss".

       78  ws-file-status-not-found          value 35.

       local-storage section.


       linkage section.

       procedure division.

       main-procedure.
           display space 
           display "---------------------------------------------------"
           display " WARNING: All current feeds will be removed!"
           display "---------------------------------------------------"
           display 
               "Are you sure you would like to reset all data files? "
               "(Y/N) "
               with no advancing 
           end-display 

           accept ws-accept-delete

           if ws-accept-delete <> "Y" and "y" then 
               display "Aborting data reset and exiting..." 
               goback
           end-if 

           call "logger" using 
               "Removing all RSS feed related data files."
           end-call 
           
           perform load-highest-rss-record
            
           perform delete-files
           
           display "Done."
           
           goback.



       load-highest-rss-record.
                      
           set ws-not-eof to true 

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



       delete-files.
           call "logger" using "Deleting files."
           
      * Delete data files up until max record id.
           if ws-last-id-record <> zero then
               display "Deleting RSS data files..."
               perform varying ws-counter 
                   from 1 by 1 until ws-counter > ws-last-id-record

                   move function concatenate(
                       "./feeds/rss_", ws-counter, ".dat") 
                       to ws-rss-dat-file-name 

                   delete file fd-rss-content-file

                   if ws-dat-file-status <> zero 
                   and ws-dat-file-status <> ws-file-status-not-found 
                   then 

                       display "Error deleting " 
                           function trim(ws-rss-dat-file-name) 
                           ". Delete status: " ws-dat-file-status
                       end-display
                       call "logger" using function concatenate(
                           "Failed to delete file: ", 
                           function trim(ws-rss-dat-file-name),
                           " : Delete status: " ws-dat-file-status)
                       end-call
                   else
                       call "logger" using function concatenate(
                           "Successfully deleted: ", 
                           function trim(ws-rss-dat-file-name),
                           " : Delete status: " ws-dat-file-status)
                       end-call 
                   end-if
               end-perform 
           else
               call "logger" using "No data files to delete. Skipping."
           end-if 

      * Delete list file
           display "Deleting RSS record list data file..."

           delete file fd-rss-list-file
           
           if ws-list-file-status <> zero 
           and ws-list-file-status <> ws-file-status-not-found then

               display "Error deleting " 
                   function trim(ws-rss-list-file-name) 
                   ". Delete status: " ws-list-file-status
               end-display
               call "logger" using function concatenate(
                   "Failed to delete file: ", 
                   function trim(ws-rss-list-file-name),
                   " : Delete status: " ws-list-file-status)
               end-call
           else
               call "logger" using function concatenate(
                   "Successfully deleted: ", 
                   function trim(ws-rss-list-file-name),
                   " : Delete status: " ws-list-file-status)
               end-call                
           end-if

      * Delete last id file.
           display "Deleting last id data file..."
           delete file fd-rss-last-id-file

           if ws-last-id-file-status <> zero
           and ws-last-id-file-status <> ws-file-status-not-found then

               display "Error deleting " 
                   function trim(ws-rss-last-id-file-name) 
                   ". Delete status: " ws-last-id-file-status
               end-display
               call "logger" using function concatenate(
                   "Failed to delete file: ", 
                   function trim(ws-rss-last-id-file-name),
                   " : Delete status: " ws-last-id-file-status)
               end-call
           else
               call "logger" using function concatenate(
                   "Successfully deleted: ", 
                   function trim(ws-rss-last-id-file-name),
                   " : Delete status: " ws-last-id-file-status)
               end-call                
           end-if



      * Delete temp file.
           display "Deleting temp data file(s)..."

           move ws-rss-temp-file-name to ws-rss-working-temp-file-name
           perform delete-temp-files

           move ws-rss-temp-retry-file-name 
               to ws-rss-working-temp-file-name
           perform delete-temp-files

           exit paragraph.



       delete-temp-files.

           if ws-rss-working-temp-file-name = spaces then 
               call "logger" using 
                   "Cannot delete temp file. No file name has been set."
               end-call 
               exit paragraph
           end-if 

           delete file fd-temp-rss-file

           if ws-temp-file-status <> 0 
           and ws-temp-file-status <> ws-file-status-not-found then

               display "Error deleting " 
                   function trim(ws-rss-working-temp-file-name) 
                   ". Delete status: " ws-temp-file-status
               end-display
               call "logger" using function concatenate(
                   "Failed to delete file: ", 
                   function trim(ws-rss-working-temp-file-name),
                   " : Delete status: " ws-temp-file-status)
               end-call
           else
               call "logger" using function concatenate(
                   "Successfully deleted: ", 
                   function trim(ws-rss-working-temp-file-name),
                   " : Delete status: " ws-temp-file-status)
               end-call                
           end-if                      
           exit paragraph.

       end program reset-files.
