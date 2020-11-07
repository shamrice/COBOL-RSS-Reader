      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-06
      * Last Modified: 2020-11-07
      * Purpose: Parses raw RSS output into RSS records.
      * Tectonics: ./build.sh
      *     cobc -x crssr.cbl rss_parser.cbl rss_reader.cbl cobweb-pipes.cob -o crssr
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
               organisation is line sequential.

       data division.
       file section.
           FD temp-rss-file.
           01 temp-rss-file-raw                    pic x(:BUFFER-SIZE:).

       working-storage section.

       01 rss-record.
           05 feed-title                       pic x(255) value spaces.
           05 feed-link                        pic x(255) value spaces.
           05 feed-desc                        pic x(255) value spaces.
           05 items                            occurs 30 times.
               10 item-exists                  pic a value 'N'.
               10 item-title                   pic x(255) value spaces.
               10 item-link                    pic x(255) value spaces.
               10 item-guid                    pic x(255) value spaces.
               10 item-pub-date                pic x(255) value spaces.
               10 item-desc                    pic x(511) value spaces.

       01 eof-sw                                   pic a value 'N'.
           88 eof                                   value 'Y'.
           88 not-eof                               value 'N'.

       77 is-desc-single-line                      pic a value 'N'.
       77 in-description                           pic a value 'N'.
       77 in-items                                 pic a value 'N'.
       77 item-idx                                 pic 99 value 1.

       77 desc-temp                            pic x(255) value spaces.

       77 raw-buffer                               pic x(:BUFFER-SIZE:).
       77 counter                                  pic 99 value 1.

       77 search-count                             pic 9 value zero.

       78 newline                                  value x"0a".

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
               move 'Y' to item-exists(item-idx)
           end-if

      *> search for title
           move zero to search-count
           inspect raw-buffer tallying search-count for all "<title>"

           if search-count > 0 then
               display "Found title: " function trim(raw-buffer)
               if in-items = 'N' then
                   display "feed title"
                   move function trim(raw-buffer) to feed-title
               else
                   display "item title"
                   move function trim(raw-buffer)
                   to item-title(item-idx)
               end-if
           end-if

      *> search for link
           move zero to search-count
           inspect raw-buffer tallying search-count for all "<link>"

           if search-count > 0 then
               display "Found link: " function trim(raw-buffer)
               if in-items = 'N' then
                   display "feed link"
                   move function trim(raw-buffer) to feed-link
               else
                   display "item link"
                   move function trim(raw-buffer)
                   to item-link(item-idx)
               end-if
           end-if

      *> search item pub date
           move zero to search-count
           inspect raw-buffer tallying search-count for all "<pubDate>"

           if search-count > 0 then
               display "Found pub date: " function trim(raw-buffer)
               if in-items = 'Y' then
                   move function trim(raw-buffer)
                   to item-pub-date(item-idx)
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
                   to item-guid(item-idx)
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
                   move function trim(raw-buffer) to feed-desc
               else
                   display "item desc single"
                   move function trim(raw-buffer)
                   to item-desc(item-idx)
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
                           function trim(feed-desc),
                           function trim(raw-buffer))
                       to feed-desc
                   else
                       display "item desc"
                       move function concatenate(
                           function trim(item-desc(item-idx)),
                           function trim(raw-buffer))
                       to item-desc(item-idx)
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
           display newline "Removing rss/xml tags from parsed record..."

           inspect rss-record replacing
               all "<title>" by low-values
               all "</title>" by low-values
               all "<link>" by low-values
               all "</link>" by low-values
               all "<guid>" by low-values
               all '<guid isPermaLink="false">' by low-values
               all '<guid isPermaLink="true">' by low-values
               all "</guid>" by low-values
               all "<pubDate>" by low-values
               all "</pubDate>" by low-values
               all "<description>" by low-values
               all "</description>" by low-values
               all "&lt;br /&gt;" by low-values
               all "&lt;br&gt;" by low-values
               all "&lt;a" by low-values
               all "target=&quot;_blank&quot;" by low-values
               all "href=&quot;" by low-values
               all "&quot;&gt;" by low-values
               all "&lt;/a&gt;" by low-values
               all "&lt;h1&gt;" by low-values
               all "&lt;/h1&gt;" by low-values
               all "&lt;hr /&gt;" by low-values
               all "&#39;" by low-values
               all "&lt;/h2&gt;" by low-values
               all "&lt;h2&gt;" by low-values

      *> TODO : new lines should eventually have a space instead of just low-values.

           exit paragraph.



       print-parsed-record.

           display newline "RSS Feed Info" newline "-------------"
           display "Feed Title: " function trim(feed-title)
           display "Feed Link: " function trim(feed-link)
           display "Feed Description: " function trim(feed-desc)
           display newline

           display "Items:" newline "------"
           move 1 to counter
           perform until counter = 30
               if item-exists(counter) = 'Y' then
                   display
                       "Item title: "
                       function trim(item-title(counter))
                   end-display
                   display
                       "Item link: "
                       function trim(item-link(counter))
                   end-display
                   display
                       "Item guid: "
                       function trim(item-guid(counter))
                   end-display
                   display
                       "Item date: "
                       function trim(item-pub-date(counter))
                   end-display
                   display
                       "Item desc: "
                       function trim(item-desc(counter))
                   end-display
                   display newline
               end-if
               add 1 to counter
           end-perform

           exit paragraph.

       exit program.
