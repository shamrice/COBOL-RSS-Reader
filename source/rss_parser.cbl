      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-06
      * Last Modified: 2020-11-16
      * Purpose: Parses raw RSS output into RSS records.
      * Tectonics: ./build.sh
      ******************************************************************

       replace ==:BUFFER-SIZE:== by ==32768==.

       identification division.
       program-id. rss-parser.

       environment division.

       configuration section.

       input-output section.
           file-control.
               select temp-rss-file
               assign to dynamic ls-file-name
               organization is line sequential.

               copy "./copybooks/filecontrol/rss_content_file.cpy".
               copy "./copybooks/filecontrol/rss_list_file.cpy".
               copy "./copybooks/filecontrol/rss_last_id_file.cpy".       
               

       data division.
       file section.
           FD temp-rss-file.
           01 temp-rss-file-raw                 pic x(:BUFFER-SIZE:).

           copy "./copybooks/filedescriptor/fd_rss_content_file.cpy".
           copy "./copybooks/filedescriptor/fd_rss_list_file.cpy".
           copy "./copybooks/filedescriptor/fd_rss_last_id_file.cpy".

                              
       working-storage section.
       
       copy "./copybooks/wsrecord/ws-rss-record.cpy".
       copy "./copybooks/wsrecord/ws-rss-list-record.cpy".
       copy "./copybooks/wsrecord/ws-last-id-record.cpy".
     

       01  eof-sw                                   pic a value 'N'.
           88 eof                                   value 'Y'.
           88 not-eof                               value 'N'.

       77  is-desc-single-line                      pic a value 'N'.
       77  in-description                           pic a value 'N'.
       77  in-items                                 pic a value 'N'.
       77  item-idx                                 pic 99 value 1.

       77  desc-temp                            pic x(255) value spaces.

       77  raw-buffer                              pic x(:BUFFER-SIZE:).
       77  counter                                 pic 99 value 1.

       77  search-count                            pic 9 value zero.

       77  next-rss-id                             pic 9(5) value zeros.
       77  temp-id                                 pic 9(5) value zeros.
       77  id-found                                pic a values 'N'.

       78  new-line                                 value x"0a".

       77  ws-rss-content-file-name pic x(21) value "./feeds/UNSET.dat".
       78  ws-rss-list-file-name              value "./feeds/list.dat".
       78  ws-rss-last-id-file-name          value "./feeds/lastid.dat".

       01  remove-space-field.
           03  rsf-leading-space       pic x.
           03  rsf-rest                pic x(100).

       linkage section.
           01 ls-file-name                       pic x(255).

       procedure division using ls-file-name.

       main-procedure.
           display "File name to parse: " ls-file-name

           display "Parsing RSS feed..."
           open input temp-rss-file
               perform until eof
                   read temp-rss-file into raw-buffer
                       at end move 'Y' to eof-sw
                   not at end
                       display function trim(raw-buffer)

                       perform parse-buffer-line

                   end-read
               end-perform
           close temp-rss-file.

           perform remove-tags-in-record
           perform print-parsed-record
           perform save-parsed-record

           goback.



       parse-buffer-line.

      *> reset single line flag each line.
           move 'N' to is-desc-single-line

      *> search for item end
           move zero to search-count
           inspect raw-buffer tallying search-count for all "</item>"

           if search-count > 0 then
               display "Found item end: " function trim(raw-buffer)
               move 'N' to in-items
               add 1 to item-idx
           end-if


      *> search for item start
           move zero to search-count
           inspect raw-buffer tallying search-count for all "<item>"

           if search-count > 0 then
               display "Found item start: " function trim(raw-buffer)
               move 'Y' to in-items
               move 'Y' to ws-item-exists(item-idx)
           end-if

      *> search for title
           move zero to search-count
           inspect raw-buffer tallying search-count for all "<title>"

           if search-count > 0 then
               display "Found title: " function trim(raw-buffer)
               if in-items = 'N' then
                   display "feed title"
                   move function trim(raw-buffer) to ws-feed-title
               else
                   display "item title"
                   move function trim(raw-buffer)
                   to ws-item-title(item-idx)
               end-if
           end-if

      *> search for link
           move zero to search-count
           inspect raw-buffer tallying search-count for all "<link>"

           if search-count > 0 then
               display "Found link: " function trim(raw-buffer)
               if in-items = 'N' then
                   display "feed link"
                   move function trim(raw-buffer) to ws-feed-link
               else
                   display "item link"
                   move function trim(raw-buffer)
                   to ws-item-link(item-idx)
               end-if
           end-if

      *> search item pub date
           move zero to search-count
           inspect raw-buffer tallying search-count for all "<pubDate>"

           if search-count > 0 then
               display "Found pub date: " function trim(raw-buffer)
               if in-items = 'Y' then
                   move function trim(raw-buffer)
                   to ws-item-pub-date(item-idx)
               end-if
           end-if

      *> search for item guid
           move zero to search-count
           inspect raw-buffer
               tallying search-count
               for all "<guid>"
                       '<guid isPermaLink="false">'
                       '<guid isPermaLink="true">'

           if search-count > 0 then
               if in-items = 'Y' then
                   display "Found guid: " function trim(raw-buffer)
                   display "item guid"
                   move function trim(raw-buffer)
                   to ws-item-guid(item-idx)
               end-if
           end-if


      *> search for single line description
           move zero to search-count
           inspect raw-buffer
           tallying search-count
               for all "<description>" "</description>"

           if search-count = 2 then
               display
                   "Found single line desc: "
                   function trim(raw-buffer)
               end-display
               move 'Y' to is-desc-single-line
               if in-items = 'N' then
                   display "feed desc single"
                   move function trim(raw-buffer) to ws-feed-desc
               else
                   display "item desc single"
                   move function trim(raw-buffer)
                   to ws-item-desc(item-idx)
               end-if
           end-if


      *> search for description
           if is-desc-single-line equals 'N' then
               move zero to search-count
               inspect raw-buffer
               tallying search-count for all "<description>"

               if search-count > 0 then
                   display "start of multiline description"
                   move 'Y' to in-description
                   move spaces to desc-temp
               end-if

               if in-description = 'Y' then
                   display "Found desc: " function trim(raw-buffer)
                   if in-items = 'N' then
                       display "feed description"
                       move function concatenate(
                           function trim(ws-feed-desc),
                           function trim(raw-buffer))
                       to ws-feed-desc
                   else
                       display "item desc"
                       move function concatenate(
                           function trim(ws-item-desc(item-idx)),
                           function trim(raw-buffer))
                       to ws-item-desc(item-idx)
                   end-if
               end-if

      *> check for end
               move zero to search-count
               inspect raw-buffer
               tallying search-count for all "</description>"

               if search-count > 0 then
                   display "end multi line description"
                   move 'N' to in-description
               end-if

           end-if

           exit paragraph.



       remove-tags-in-record.
           display new-line "Removing rss/xml tags from parsed record.."

           inspect ws-rss-record replacing all 
                "<title>" by spaces
                "</title>" by spaces
                "<link>" by spaces
                "</link>" by spaces
                "<guid>" by spaces
                '<guid isPermaLink="false">' by spaces
                '<guid isPermaLink="true">' by spaces
                "</guid>" by spaces
                "<pubDate>" by spaces
                "</pubDate>" by spaces
                "<description>" by spaces
                "</description>" by spaces
                "&lt;br /&gt;" by spaces
                "&lt;br&gt;" by spaces
                "&lt;a" by spaces
                "target=&quot;_blank&quot;" by spaces
                "href=&quot;" by spaces
                "&quot;&gt;" by spaces
                "&lt;/a&gt;" by spaces
                "&lt;h1&gt;" by spaces
                "&lt;/h1&gt;" by spaces
                "&lt;hr /&gt;" by spaces
                "&#39;" by spaces
                "&lt;/h2&gt;" by spaces
                "&lt;h2&gt;" by spaces

      *> TODO : new lines should eventually have a space instead of just low-values.

           exit paragraph.



       print-parsed-record.

           display new-line "RSS Feed Info" new-line "-------------"
           display "Feed Title: " function trim(ws-feed-title)
           display "Feed Link: " function trim(ws-feed-link)
           display "Feed Description: " function trim(ws-feed-desc)
           display new-line

           display "Items:" new-line "------"
           move 1 to counter
           perform until counter > ws-max-rss-items
               if ws-item-exists(counter) = 'Y' then
                   display
                       "Item title: "
                       function trim(ws-item-title(counter))
                   end-display
                   display
                       "Item link: "
                       function trim(ws-item-link(counter))
                   end-display
                   display
                       "Item guid: "
                       function trim(ws-item-guid(counter))
                   end-display
                   display
                       "Item date: "
                       function trim(ws-item-pub-date(counter))
                   end-display
                   display
                       "Item desc: "
                       function trim(ws-item-desc(counter))
                   end-display
                   display new-line
               end-if
               add 1 to counter
           end-perform

           exit paragraph.


       save-parsed-record.

           display "Checking if entry exists in RSS list data."
           
      *> make sure file exists... 
           open extend rss-list-file close rss-list-file

      * set idx search value
           move ws-feed-link to rss-link

           open input rss-list-file
               read rss-list-file into ws-rss-list-record
                   key is rss-link
                   invalid key 
                       display "RSS Feed URL Not Found: " rss-link
                   not invalid key 
                       display "Found:" ws-rss-list-record
                       move 'Y' to id-found
               end-read       
           close rss-list-file

           if id-found = 'N' then 
               perform set-new-feed-id
               move next-rss-id to ws-feed-id
           else 
               display "Using existing id: " ws-rss-feed-id
               move ws-rss-feed-id to ws-feed-id
           end-if


           display "Updating/Adding record to RSS list data."
           
           
           move ws-feed-id to ws-rss-feed-id
           

           move function concatenate(
               "./feeds/rss_", ws-feed-id, ".dat")
               to ws-rss-dat-file-name

           move function trim(ws-rss-dat-file-name)
           to ws-rss-content-file-name
           
           move function trim(ws-feed-title) 
           to ws-rss-title
           
           move function trim(ws-feed-link)
           to ws-rss-link

           display ws-rss-list-record

           open i-o rss-list-file
               write rss-list-record from ws-rss-list-record
                   invalid key 
                       display "RSS Feed already exists in list."
                   not invalid key 
                       display "Saved new RSS Feed to idx file"
               end-write
           close rss-list-file


           display "Saving parsed RSS data to disk...".

           open output rss-content-file    
               write rss-content-record from ws-rss-record
               end-write
           close rss-content-file

           exit paragraph.


       set-new-feed-id.
           
           display "Getting last id saved."

             *> make sure file exists... 
           open extend rss-last-id-file close rss-last-id-file
           
           move 'N' to eof-sw

           open input rss-last-id-file
               perform until eof
                   read rss-last-id-file into ws-last-id-record
                       at end move 'Y' to eof-sw
                   not at end
                       display ws-last-id-record
                       if ws-last-id-record is numeric then 
                           move ws-last-id-record to next-rss-id
                       end-if 

                   end-read
               end-perform
           close rss-last-id-file

           display "last RSS ID found: " next-rss-id
           add 1 to next-rss-id
           display "Next new RSS ID: " next-rss-id

           display 
               "Saving new RSS ID " next-rss-id " to last id data file."
           end-display

           open output rss-last-id-file
               write rss-last-id-record from next-rss-id
               end-write
           close rss-last-id-file

           exit paragraph.       

       end program rss-parser.
