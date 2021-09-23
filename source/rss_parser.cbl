      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-06
      * Last Modified: 2021-09-23
      * Purpose: Parses raw RSS output into RSS records.
      * Tectonics: ./build.sh
      ******************************************************************
       replace ==:BUFFER-SIZE:== by ==32768==.

       identification division.
       function-id. rss-parser.

       environment division.

       configuration section.

       repository.
           function sanitize-rss-field
           function remove-leading-spaces.
           
       input-output section.
           file-control.
               select fd-temp-rss-file
               assign to dynamic l-file-name
               organization is line sequential.

               copy "./copybooks/filecontrol/rss_content_file.cpy".
               copy "./copybooks/filecontrol/rss_list_file.cpy".
               copy "./copybooks/filecontrol/rss_last_id_file.cpy".       
               
       data division.
       file section.
           FD fd-temp-rss-file.
           01 f-temp-rss-file-raw                 pic x(:BUFFER-SIZE:).

           copy "./copybooks/filedescriptor/fd_rss_content_file.cpy".
           copy "./copybooks/filedescriptor/fd_rss_list_file.cpy".
           copy "./copybooks/filedescriptor/fd_rss_last_id_file.cpy".


       working-storage section.

       77  ws-rss-content-file-name          pic x(21) 
                                             value "./feeds/UNSET.dat".
       78  ws-rss-list-file-name             value "./feeds/list.dat".
       78  ws-rss-last-id-file-name          value "./feeds/lastid.dat".

 
      * variable values are not persisted between runs for local storage                              
       local-storage section.
       
       copy "./copybooks/wsrecord/ws-rss-record.cpy".
       copy "./copybooks/wsrecord/ws-rss-list-record.cpy".
       copy "./copybooks/wsrecord/ws-last-id-record.cpy".
     
       01  ls-eof-sw                             pic a value 'N'.
           88 ls-eof                                   value 'Y'.
           88 ls-not-eof                               value 'N'.

       77  ls-is-desc-single-line                pic a value 'N'.
       77  ls-in-description                     pic a value 'N'.
       77  ls-in-items                           pic a value 'N'.      

       77  ls-raw-buffer                         pic x(:BUFFER-SIZE:) 
                                                 value spaces.

       77  ls-counter                            pic 9(6) comp value 1.

       77  ls-search-count                     pic 999 comp value zeros.

       77  ls-next-rss-id                     pic 9(5) comp value zeros.
       
       77  ls-next-rss-id-display             pic 9(5).

       77  ls-id-found                           pic a values 'N'.
       

       linkage section.
           01  l-file-name                       pic x(255).
           01  l-feed-url                        pic x(256).

           01  l-parse-status                    pic S9 value zero.
               88 l-return-status-success               value 1.
               88 l-return-status-fail                  value 2.

       procedure division 
           using l-file-name l-feed-url
           returning l-parse-status.

       main-procedure.

           call "logger" using function concatenate(
               "File name to parse: ", function trim(l-file-name),
               " Source feed url: ", function trim(l-feed-url))
           end-call

           call "logger" using "Parsing RSS feed..."
           open input fd-temp-rss-file
               perform until ls-eof
                   read fd-temp-rss-file into ls-raw-buffer
                       at end set ls-eof to true
                   not at end
                       call "logger" using function trim(ls-raw-buffer)

                       perform parse-buffer-line

                   end-read
               end-perform
           close fd-temp-rss-file.

           perform remove-tags-in-record
           perform log-parsed-record
           perform save-parsed-record

           if l-parse-status is zero then     
               set l-return-status-success to true 
           end-if

           goback.



       parse-buffer-line.

      *> reset single line flag each line.
           move 'N' to ls-is-desc-single-line

      *> search for item end
           move zero to ls-search-count
           inspect ls-raw-buffer 
               tallying ls-search-count for all "</item>"

           if ls-search-count > 0 then
               call "logger" using function concatenate(
                   "Found item end: ", function trim(ls-raw-buffer))
               end-call
               move 'N' to ls-in-items                       
           end-if


      *> search for item start
           move zero to ls-search-count
           inspect ls-raw-buffer 
               tallying ls-search-count for all "<item>"

           if ls-search-count > 0 then
               add 1 to ws-num-items
               call "logger" using function concatenate(
                   "Found item start: ", function trim(ls-raw-buffer))
               end-call
               move 'Y' to ls-in-items             
           end-if

      *> search for title
           move zero to ls-search-count
           inspect ls-raw-buffer 
                tallying ls-search-count for all "<title>"

           if ls-search-count > 0 then
               call "logger" using function concatenate(
                   "Found title: ", function trim(ls-raw-buffer))
               end-call
               if ls-in-items = 'N' then
                   call "logger" using "feed title"
                   move function trim(ls-raw-buffer) to ws-feed-title
               else
                   call "logger" using "item title"
                   move function trim(ls-raw-buffer)
                   to ws-item-title(ws-num-items)
               end-if
           end-if

      *> search for link
           move zero to ls-search-count
           inspect ls-raw-buffer 
               tallying ls-search-count for all "<link>"

           if ls-search-count > 0 then
               call "logger" using function concatenate(
                   "Found link: ", function trim(ls-raw-buffer))
               end-call
               if ls-in-items = 'N' then
                   call "logger" using "feed site link"
                   move function trim(ls-raw-buffer) 
                       to ws-feed-site-link
               else
                   call "logger" using "item link"
                   move function trim(ls-raw-buffer)
                   to ws-item-link(ws-num-items)
               end-if
           end-if

      *> search item pub date
           move zero to ls-search-count
           inspect ls-raw-buffer 
               tallying ls-search-count for all "<pubDate>"

           if ls-search-count > 0 then
               call "logger" using function concatenate(
                   "Found pub date: ", function trim(ls-raw-buffer))
               end-call
               if ls-in-items = 'Y' then
                   move function trim(ls-raw-buffer)
                   to ws-item-pub-date(ws-num-items)
               end-if
           end-if

      *> search for item guid
           move zero to ls-search-count
           inspect ls-raw-buffer
               tallying ls-search-count
               for all "<guid>"
                       '<guid isPermaLink="false">'
                       '<guid isPermaLink="true">'

           if ls-search-count > 0 then
               if ls-in-items = 'Y' then
                   call "logger" using function concatenate(
                       "Found guid: " function trim(ls-raw-buffer))
                   end-call 
                   
                   move function trim(ls-raw-buffer)
                   to ws-item-guid(ws-num-items)
               end-if
           end-if


      *> search for single line description
           move zero to ls-search-count
           inspect ls-raw-buffer
               tallying ls-search-count
               for all "<description>" "</description>"

           if ls-search-count = 2 then
               call "logger" using function concatenate(
                   "Found single line desc: ",
                   function trim(ls-raw-buffer))
               end-call
               move 'Y' to ls-is-desc-single-line
               if ls-in-items = 'N' then
                   call "logger" using "feed desc single"
                   move function trim(ls-raw-buffer) to ws-feed-desc
               else
                   call "logger" using function concatenate( 
                       "item desc single: ", ls-raw-buffer)
                   end-call
                   move function trim(ls-raw-buffer)
                   to ws-item-desc(ws-num-items)
               end-if
           end-if


      *> search for description
           if ls-is-desc-single-line equals 'N' then
               move zero to ls-search-count
               inspect ls-raw-buffer
                   tallying ls-search-count for all "<description>"

               if ls-search-count > 0 then
                   call "logger" using "start of multiline description"
                   move 'Y' to ls-in-description                  
                   move spaces to ws-item-desc(ws-num-items)
               end-if

               if ls-in-description = 'Y' then
                   call "logger" using function concatenate(
                       "Found desc: " function trim(ls-raw-buffer))
                   end-call 
                   if ls-in-items = 'N' then
                       call "logger" using "feed description"
                       move function concatenate(
                           function trim(ws-feed-desc),
                           function trim(ls-raw-buffer))
                       to ws-feed-desc
                   else
                       call "logger" using "item desc"                        
                       move function concatenate(
                           function trim(ws-item-desc(ws-num-items)),
                           function trim(ls-raw-buffer))
                       to ws-item-desc(ws-num-items)
                       call "logger" using 
                           by content ws-item-desc(ws-num-items)
                       end-call 
                   end-if
               end-if

      *> check for end
               move zero to ls-search-count
               inspect ls-raw-buffer
                   tallying ls-search-count for all "</description>"

               if ls-search-count > 0 then
                   call "logger" using "end multi line description"
                   call "logger" using function concatenate( 
                       "item desc multi" function trim(ls-raw-buffer))
                   end-call
                   move 'N' to ls-in-description
               end-if

           end-if

           exit paragraph.



       remove-tags-in-record.
           call "logger" using 
               "Removing rss/xml tags from parsed record..."
           end-call

      * Sanitize RSS feed info.
           move function sanitize-rss-field(ws-feed-title) 
               to ws-feed-title

           move function sanitize-rss-field(ws-feed-site-link) 
               to ws-feed-site-link

           move function sanitize-rss-field(ws-feed-desc) 
               to ws-feed-desc

      * Sanitize rss item fields...

           move ws-num-items to ws-num-items-disp
           call "logger" using function concatenate(
               "Sanitizing items.. num items: " ws-num-items-disp)
           end-call 

           if ws-num-items > 0 then 

               perform varying ls-counter from 1 by 1 
                   until ls-counter > ws-num-items

                   move function 
                       sanitize-rss-field(ws-item-title(ls-counter)) 
                       to ws-item-title(ls-counter)

                   move function 
                       sanitize-rss-field(ws-item-guid(ls-counter)) 
                       to ws-item-guid(ls-counter)

                   move function 
                       sanitize-rss-field(ws-item-pub-date(ls-counter)) 
                       to ws-item-pub-date(ls-counter)

                   move function 
                       sanitize-rss-field(ws-item-link(ls-counter)) 
                       to ws-item-link(ls-counter)

                   move function 
                       sanitize-rss-field(ws-item-desc(ls-counter)) 
                       to ws-item-desc(ls-counter)

               end-perform
           end-if 

           exit paragraph.



       log-parsed-record.

           call "logger" using "RSS Feed Info:"
           call "logger" using function concatenate( 
               "Feed Title: ", function trim(ws-feed-title))
           end-call
           call "logger" using function concatenate(
               "Feed Site URL: ", function trim(ws-feed-site-link))
           end-call
           call "logger" using function concatenate(
               "Feed Description: ", function trim(ws-feed-desc))
           end-call
           
           if ws-num-items > 0 then 
               move ws-num-items to ws-num-items-disp
               call "logger" using function concatenate( 
                   "Feed Items: " ws-num-items-disp)
               end-call
           
               perform varying ls-counter from 1 by 1 
               until ls-counter > ws-num-items
              
                   call "logger" using function concatenate(
                       "Item title: ",
                       function trim(ws-item-title(ls-counter)))
                   end-call
                   call "logger" using function concatenate(
                          "Item link: ",
                       function trim(ws-item-link(ls-counter)))
                   end-call
                   call "logger" using function concatenate(
                       "Item guid: ",
                       function trim(ws-item-guid(ls-counter)))
                   end-call
                   call "logger" using function concatenate(
                       "Item date: ",
                       function trim(ws-item-pub-date(ls-counter)))
                   end-call
                   call "logger" using function concatenate(
                          "Item desc: ",
                       function trim(ws-item-desc(ls-counter)))
                   end-call
            
               end-perform
           end-if 

           exit paragraph.


       save-parsed-record.

           call "logger" using 
               "Checking if entry exists in RSS list data."
           end-call

      *> make sure file exists... 
           open extend fd-rss-list-file close fd-rss-list-file

           if ws-feed-site-link = spaces then
               call "logger" using function concatenate( 
                   "RSS Feed Link in parsed response is empty. Feed ",
                   "data cannot be saved. Please check the url and try",
                   " again.")
               end-call
               set l-return-status-fail to true
               exit paragraph 
           end-if
                   

      * set idx search value is RSS feed url
           move function trim(l-feed-url) to f-rss-link

           open input fd-rss-list-file
               read fd-rss-list-file into ws-rss-list-record
                   key is f-rss-link
                   invalid key 
                       call "logger" using function concatenate(
                           "RSS Feed URL Not Found: ", f-rss-link)
                       end-call
                   not invalid key 
                       call "logger" using function concatenate(
                           "Found:", ws-rss-list-record)
                       end-call
                       move 'Y' to ls-id-found
               end-read       
           close fd-rss-list-file

           if ls-id-found = 'N' then 
               perform set-new-feed-id
               move ls-next-rss-id to ws-feed-id
           else 
               call "logger" using function concatenate(
                   "Using existing id: ", ws-rss-feed-id)
               end-call
               move ws-rss-feed-id to ws-feed-id
           end-if


           call "logger" using "Updating/Adding record to RSS list data"
           
           
           move ws-feed-id to ws-rss-feed-id
           

           move function concatenate(
               "./feeds/rss_", ws-feed-id, ".dat")
               to ws-rss-dat-file-name

           move function trim(ws-rss-dat-file-name)
           to ws-rss-content-file-name
           
           move function trim(ws-feed-title) 
           to ws-rss-title
           
           move function trim(l-feed-url)
           to ws-rss-link

           call "logger" using function concatenate(
               "ws-rss-link: ", ws-rss-link)
           end-call

           call "logger" using ws-rss-list-record
           move ws-num-items to ws-num-items-disp
           call "logger" using ws-num-items-disp

           open i-o fd-rss-list-file
               write f-rss-list-record from ws-rss-list-record
                   invalid key 
                       call "logger" using 
                           "RSS Feed already exists in list."
                       end-call 
                   not invalid key 
                       call "logger" using 
                           "Saved new RSS Feed to idx file"
                       end-call 
               end-write
           close fd-rss-list-file


           call "logger" using "Saving parsed RSS data to disk...".

           call "logger" using ws-rss-record

           open output fd-rss-content-file    
               write f-rss-content-record from ws-rss-record
               end-write
           close fd-rss-content-file

           exit paragraph.


       set-new-feed-id.
           
           call "logger" using "Getting last id saved."

             *> make sure file exists... 
           open extend fd-rss-last-id-file close fd-rss-last-id-file
           
           set ls-not-eof to true 

           open input fd-rss-last-id-file
               perform until ls-eof
                   read fd-rss-last-id-file into ws-last-id-record
                       at end set ls-eof to true
                   not at end
                       call "logger" using ws-last-id-record
                       if ws-last-id-record is numeric then 
                           move ws-last-id-record to ls-next-rss-id
                       end-if 

                   end-read
               end-perform
           close fd-rss-last-id-file

           move ls-next-rss-id to ls-next-rss-id-display

           call "logger" using function concatenate(
               "last RSS ID found: ", ls-next-rss-id-display)
           end-call 
           add 1 to ls-next-rss-id
           move ls-next-rss-id to ls-next-rss-id-display
           call "logger" using function concatenate(
               "Next new RSS ID: ", ls-next-rss-id-display)
           end-call

           call "logger" using function concatenate( 
               "Saving new RSS ID ", ls-next-rss-id-display,
               " to last id data file.")
           end-call

           open output fd-rss-last-id-file
               write f-rss-last-id-record from ls-next-rss-id
               end-write
           close fd-rss-last-id-file

           exit paragraph. 


       end function rss-parser.
