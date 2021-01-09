      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2021-01-09
      *> Last Updated: 2021-01-09
      *> Purpose: Removes leading spaces from field passed.
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************
       replace ==:BUFFER-SIZE:== by ==32768==.

       identification division.
       function-id. remove-leading-spaces.

       environment division.

       configuration section.

       repository.

       data division.

       working-storage section.

           01  ws-space-count                  pic 9(5) value zeros.
           01  ws-length                       pic 9(5) value zeros.
           01  ws-final-offset                 pic 9(5) value zeros.

           01  ws-non-space-found-sw        pic a.
               88  ws-non-space-found       value 'Y'.
               88  ws-non-space-not-found   value 'N'.

       linkage section.
           01  ls-field               pic x any length.
           01  ls-updated-record      pic x(:BUFFER-SIZE:) value spaces.

       procedure division 
           using ls-field
           returning ls-updated-record.

       main-procedure.
           
           initialize ls-updated-record

           move function length(ls-field) to ws-length

           call "logger" using 
               function concatenate("Removing leading spaces from: ", 
               function trim(ls-field), " Length: ", ws-length)
           end-call

           set ws-non-space-not-found to true 

           perform varying ws-space-count 
               from 1 by 1 until ws-non-space-found

               if ls-field(ws-space-count:) greater than space then
                   set ws-non-space-found to true
               else 
                   if ws-space-count > ws-length then 
                       set ws-non-space-found to true 
                       move 1 to ws-space-count
                   end-if 
               end-if
           end-perform

           compute ws-final-offset = ws-length - ws-space-count

           call "logger" using function concatenate("Found ", 
               ws-space-count, " leading spaces in field. Length: ",
               ws-length, " : Final offset: ", ws-final-offset)
           end-call

           move ls-field(ws-space-count:ws-final-offset) 
               to ls-updated-record

           goback.

       end function remove-leading-spaces.


      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2021-01-09
      *> Last Updated: 2021-01-09
      *> Purpose: Removes tags and converts HTML encoded string values.
      *>          Also calls function to remove leading spaces from field.
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************
       replace ==:BUFFER-SIZE:== by ==32768==.

       identification division.
       function-id. sanitize-rss-field.

       environment division.

       configuration section.

       repository.
           function remove-leading-spaces.

       data division.

       working-storage section.

       linkage section.
           01  ls-field               pic x any length.
           01  ls-updated-record      pic x(:BUFFER-SIZE:) value spaces.

       procedure division 
           using ls-field
           returning ls-updated-record.

       main-procedure.
           
           initialize ls-updated-record

           if ls-field = spaces then 
               call "logger" using "No value to sanitize. Returning."
               move ls-field to ls-updated-record
               goback
           end-if
           

           call "logger" using 
               function concatenate("Sanitizing raw RSS field: ", 
               function trim(ls-field))
           end-call

           move function substitute(ls-field, 
               "&amp;", "&",
               "&#38;", "&",
               "&#8211;", "-",
               "<description>", space, 
               "</description>", space,
               "<title>", space, 
               "</title>", space,
               "<link>", space, 
               "</link>", space,
               "<guid>", space, 
               '<guid isPermaLink="false">', space,
               '<guid isPermaLink="true">', space,
               "</guid>", space,
               "<pubDate>", space, 
               "</pubDate>", space,
               "&lt;br /&gt;", space,
               "&lt;br&gt;", space,
               "&lt;a", space,
               "target=&quot;_blank&quot;", space,
               "href=&quot;", space,
               "&quot;&gt;", space,
               "&lt;/a&gt;", space,
               "&lt;h1&gt;", space,
               "&lt;/h1&gt;", space,
               "&lt;hr /&gt;", space,
               "&#39;", "'",
               "&quot;", '"',
               "&lt;/h2&gt;", space,
               "&lt;h2&gt;", space,
               "&lt;pre&gt;", space,
               "&lt;/pre&gt;", space)       
               to ls-field     

           move function remove-leading-spaces(ls-field) 
               to ls-updated-record
       
           goback.

       end function sanitize-rss-field.
