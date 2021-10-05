      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2021-01-09
      *> Last Updated: 2021-10-05
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

       local-storage section.       
       01  ls-length                       pic 9(5) value zeros.

       01  ls-temp-record                  pic x(:BUFFER-SIZE:).

       linkage section.
       01  l-field                         pic x any length.
       01  l-updated-record                pic x(:BUFFER-SIZE:) 
                                               value spaces.

       procedure division 
           using l-field
           returning l-updated-record.

       main-procedure.
           
           initialize l-updated-record

           move function length(l-field) to ls-length

           call "logger" using 
               function concatenate("Removing leading spaces from: ", 
               function trim(l-field), " Length: ", ls-length)
           end-call

           move function trim(l-field) to ls-temp-record
           move ls-temp-record to l-updated-record
           goback.

       end function remove-leading-spaces.


      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2021-01-09
      *> Last Updated: 2021-10-05
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
       01  l-field               pic x any length.
       01  l-updated-record      pic x(:BUFFER-SIZE:) value spaces.

       procedure division 
           using l-field
           returning l-updated-record.

       main-procedure.
           
           initialize l-updated-record

           if l-field = spaces then 
               call "logger" using "No value to sanitize. Returning."
               move l-field to l-updated-record
               goback
           end-if
           
           call "logger" using 
               function concatenate("Sanitizing raw RSS field: ", 
               function trim(l-field))
           end-call

           move function substitute-case(l-field, 
               "&amp;", "&",
               "&#38;", "&",
               "&#038;", "&",
               "&#8211;", "-",
               "&#8217;", "'",
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
               "&lt;b&gt;", space,
               "&lt;/b&gt;", space,
               "&lt;a", space,
               "&lt;/p", space,
               "&lt;p", space   
               "&lt;span", space,
               "&lt;/span", space,              
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
               "&lt;/pre&gt;", space,
               "&lt;u&gt;", space,
               "&lt;/u&gt;", space,   
               "<![CDATA[", space,
               "]]>", space,
               '<a href="', space,
               '">', space,
               "</a>", space,
               "<p>", space,
               "</p>", space,
               "<i>", space, 
               "</i>", space,
               "<u>", space,
               "</u>", space,
               "<b>", space,
               "</b>", space,
               "&lt;", space,
               "/&gt;", space,
               "&gt;", space
               ) to l-field  

           move function remove-leading-spaces(l-field) 
               to l-updated-record
       
           goback.

       end function sanitize-rss-field.
