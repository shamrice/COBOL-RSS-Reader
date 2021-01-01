      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-06
      * Last Modified: 2021-01-01
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

       77  raw-buffer                 pic x(:BUFFER-SIZE:) value spaces.
       77  raw-buffer-2               pic x(:BUFFER-SIZE:) value spaces.
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
           01  ls-file-name                       pic x(255).
           01  ls-feed-url                        pic x(256).

       procedure division using ls-file-name ls-feed-url.

       main-procedure.

           call "logger" using function concatenate(
               "File name to parse: ", function trim(ls-file-name),
               " Source feed url: ", function trim(ls-feed-url))
           end-call

      * Values persist between follow up calls to subprogram. need clear
           move 'N' to eof-sw
           move spaces to raw-buffer
           move 1 to item-idx
           perform reset-ws-items         

           call "logger" using "Parsing RSS feed..."
           open input temp-rss-file
               perform until eof
                   read temp-rss-file into raw-buffer
                       at end move 'Y' to eof-sw
                   not at end
                       call "logger" using function trim(raw-buffer)

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
               call "logger" using function concatenate(
                   "Found item end: ", function trim(raw-buffer))
               end-call
               move 'N' to in-items
               add 1 to item-idx
           end-if


      *> search for item start
           move zero to search-count
           inspect raw-buffer tallying search-count for all "<item>"

           if search-count > 0 then
               call "logger" using function concatenate(
                   "Found item start: ", function trim(raw-buffer))
               end-call
               move 'Y' to in-items
               move 'Y' to ws-item-exists(item-idx)
           end-if

      *> search for title
           move zero to search-count
           inspect raw-buffer tallying search-count for all "<title>"

           if search-count > 0 then
               call "logger" using function concatenate(
                   "Found title: ", function trim(raw-buffer))
               end-call
               if in-items = 'N' then
                   call "logger" using "feed title"
                   move function trim(raw-buffer) to ws-feed-title
               else
                   call "logger" using "item title"
                   move function trim(raw-buffer)
                   to ws-item-title(item-idx)
               end-if
           end-if

      *> search for link
           move zero to search-count
           inspect raw-buffer tallying search-count for all "<link>"

           if search-count > 0 then
               call "logger" using function concatenate(
                   "Found link: ", function trim(raw-buffer))
               end-call
               if in-items = 'N' then
                   call "logger" using "feed site link"
                   move function trim(raw-buffer) to ws-feed-site-link
               else
                   call "logger" using "item link"
                   move function trim(raw-buffer)
                   to ws-item-link(item-idx)
               end-if
           end-if

      *> search item pub date
           move zero to search-count
           inspect raw-buffer tallying search-count for all "<pubDate>"

           if search-count > 0 then
               call "logger" using function concatenate(
                   "Found pub date: ", function trim(raw-buffer))
               end-call
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
                   call "logger" using function concatenate(
                       "Found guid: " function trim(raw-buffer))
                   end-call 
                   
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
               call "logger" using function concatenate(
                   "Found single line desc: ",
                   function trim(raw-buffer))
               end-call
               move 'Y' to is-desc-single-line
               if in-items = 'N' then
                   call "logger" using "feed desc single"
                   move function trim(raw-buffer) to ws-feed-desc
               else
                   call "logger" using "item desc single"
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
                   call "logger" using "start of multiline description"
                   move 'Y' to in-description
                   move spaces to desc-temp
               end-if

               if in-description = 'Y' then
                   call "logger" using function concatenate(
                       "Found desc: " function trim(raw-buffer))
                   end-call 
                   if in-items = 'N' then
                       call "logger" using "feed description"
                       move function concatenate(
                           function trim(ws-feed-desc),
                           function trim(raw-buffer))
                       to ws-feed-desc
                   else
                       call "logger" using "item desc"
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
                   call "logger" using "end multi line description"
                   move 'N' to in-description
               end-if

           end-if

           exit paragraph.



       remove-tags-in-record.
           call "logger" using 
               "Removing rss/xml tags from parsed record..."
           end-call

      * Sanitize RSS feed info.
           move function substitute(ws-feed-title, 
               "&amp;", "&",
               "&#38;", "&",
               "&quot;", '"',
               "<title>", space, 
               "</title>", space,
               "&#39;", "'") 
               to ws-feed-title

           move function substitute(ws-feed-site-link, 
               "&amp;", "&",
               "&#38;", "&",
               "<link>", space, 
               "</link>", space) 
               to ws-feed-site-link
           
           move function substitute(ws-feed-desc, 
               "&amp;", "&",
               "&#38;", "&",
               "&quot;", '"',
               "<description>", space, 
               "</description>", space
               "&#39;", "'") 
               to ws-feed-desc

      * Sanitize rss item fields...
           move 1 to counter
           perform until counter = ws-max-rss-items

               move function substitute(ws-item-title(counter), 
                   "&amp;", "&",
                   "&#38;", "&",
                   "&#038;", "&",
                   "<title>", space, 
                   "</title>", space,
                   "&#39;", "'",
                   "&quot;", '"') 
                   to ws-item-title(counter)

               move function substitute(ws-item-guid(counter), 
                   "&amp;", "&",
                   "&#38;", "&",
                   "<guid>", space, 
                   '<guid isPermaLink="false">', space,
                   '<guid isPermaLink="true">', space,
                   "</guid>", space)
                   to ws-item-guid(counter)

               move function substitute(ws-item-pub-date(counter), 
                   "<pubDate>", space, 
                   "</pubDate>", space)
                   to ws-item-pub-date(counter)

               move function substitute(ws-item-link(counter), 
                   "&amp;", "&",
                   "&#38;", "&",
                   "<link>", space, 
                   "</link>", space) 
                   to ws-item-link(counter)

               move function substitute(ws-item-desc(counter), 
                   "&amp;", "&",
                   "&#38;", "&",
                   "<description>", space, 
                   "</description>", space
                   "&lt;br /&gt;", space
                   "&lt;br&gt;", space
                   "&lt;a", space
                   "target=&quot;_blank&quot;", space
                   "href=&quot;", space
                   "&quot;&gt;", space
                   "&lt;/a&gt;", space
                   "&lt;h1&gt;", space
                   "&lt;/h1&gt;", space
                   "&lt;hr /&gt;", space
                   "&#39;", "'",
                   "&quot;", '"',
                   "&lt;/h2&gt;", space
                   "&lt;h2&gt;", space,
                   "&lt;pre&gt;", space,
                   "&lt;/pre&gt;", space) 
                   to ws-item-desc(counter)

               add 1 to counter 
           end-perform

           exit paragraph.



       print-parsed-record.

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
           
           call "logger" using "Feed Items:"
           move 1 to counter
           perform until counter > ws-max-rss-items
               if ws-item-exists(counter) = 'Y' then
                   call "logger" using function concatenate(
                       "Item title: ",
                       function trim(ws-item-title(counter)))
                   end-call
                   call "logger" using function concatenate(
                       "Item link: ",
                       function trim(ws-item-link(counter)))
                   end-call
                   call "logger" using function concatenate(
                       "Item guid: ",
                       function trim(ws-item-guid(counter)))
                   end-call
                   call "logger" using function concatenate(
                       "Item date: ",
                       function trim(ws-item-pub-date(counter)))
                   end-call
                   call "logger" using function concatenate(
                       "Item desc: ",
                       function trim(ws-item-desc(counter)))
                   end-call
               end-if
               add 1 to counter
           end-perform

           exit paragraph.


       save-parsed-record.

           call "logger" using 
               "Checking if entry exists in RSS list data."
           end-call

      *> make sure file exists... 
           open extend rss-list-file close rss-list-file

           if ws-feed-site-link = spaces then
               call "logger" using function concatenate( 
                   "RSS Feed Link in parsed response is empty. Feed ",
                   "data cannot be saved. Please check the url and try",
                   " again.")
               end-call
               exit paragraph
           end-if
                   

      * set idx search value is RSS feed url
           move function trim(ls-feed-url) to rss-link

           open input rss-list-file
               read rss-list-file into ws-rss-list-record
                   key is rss-link
                   invalid key 
                       call "logger" using function concatenate(
                           "RSS Feed URL Not Found: ", rss-link)
                       end-call
                   not invalid key 
                       call "logger" using function concatenate(
                           "Found:", ws-rss-list-record)
                       end-call
                       move 'Y' to id-found
               end-read       
           close rss-list-file

           if id-found = 'N' then 
               perform set-new-feed-id
               move next-rss-id to ws-feed-id
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
           
           move function trim(ls-feed-url)
           to ws-rss-link

           call "logger" using function concatenate(
               "ws-rss-link: ", ws-rss-link)
           end-call

           call "logger" using ws-rss-list-record

           open i-o rss-list-file
               write rss-list-record from ws-rss-list-record
                   invalid key 
                       call "logger" using 
                           "RSS Feed already exists in list."
                       end-call 
                   not invalid key 
                       call "logger" using 
                           "Saved new RSS Feed to idx file"
                       end-call 
               end-write
           close rss-list-file


           call "logger" using "Saving parsed RSS data to disk...".

           open output rss-content-file    
               write rss-content-record from ws-rss-record
               end-write
           close rss-content-file

           exit paragraph.


       set-new-feed-id.
           
           call "logger" using "Getting last id saved."

             *> make sure file exists... 
           open extend rss-last-id-file close rss-last-id-file
           
           move 'N' to eof-sw

           open input rss-last-id-file
               perform until eof
                   read rss-last-id-file into ws-last-id-record
                       at end move 'Y' to eof-sw
                   not at end
                       call "logger" using ws-last-id-record
                       if ws-last-id-record is numeric then 
                           move ws-last-id-record to next-rss-id
                       end-if 

                   end-read
               end-perform
           close rss-last-id-file

           call "logger" using function concatenate(
               "last RSS ID found: ", next-rss-id)
           end-call 
           add 1 to next-rss-id
           call "logger" using function concatenate(
               "Next new RSS ID: ", next-rss-id)
           end-call

           call "logger" using function concatenate( 
               "Saving new RSS ID ", next-rss-id, 
               " to last id data file.")
           end-call

           open output rss-last-id-file
               write rss-last-id-record from next-rss-id
               end-write
           close rss-last-id-file

           exit paragraph. 

       reset-ws-items.
           move 1 to counter
           perform until counter = ws-max-rss-items
               move 'N' to ws-item-exists(counter)
               move spaces to ws-item-title(counter)
               move spaces to ws-item-link(counter)
               move spaces to ws-item-guid(counter)
               move spaces to ws-item-pub-date(counter)
               move spaces to ws-item-desc(counter)

               add 1 to counter
           end-perform
           
           exit paragraph.                 

       end program rss-parser.
