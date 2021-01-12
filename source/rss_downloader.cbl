      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2020-12-21
      *> Last Updated: 2021-01-12
      *> Purpose: Downloads given RSS feed url and calls rss_parser
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************

       replace ==:BUFFER-SIZE:== by ==32768==.

       identification division.
       function-id. rss-downloader.

       environment division.

       configuration section.

       repository.
           function pipe-open
           function pipe-close
           function rss-parser.

       data division.

       working-storage section.

      *> a file pointer
       01  ws-pipe-record.
           05 ws-pipe-pointer                  usage pointer.
           05 ws-pipe-return                   usage binary-long.

       77  ws-rss-temp-filename                pic x(255)
                                               value "./feeds/temp.rss".

       78  ws-wget                             value "wget -q -O ".
      
       local-storage section.

       77  ls-download-cmd                     pic x(:BUFFER-SIZE:).

       77  ls-rss-feed-url                     pic x(256) value spaces.

       77  ls-download-status                  pic 9 value 9.

       77  ls-parse-status                     pic S9 value 0.

       linkage section.
           01  l-feed-url                         pic x(256).

           01  l-download-and-parse-status        pic 9 value zero.
               88  l-return-status-success        value 1.
               88  l-return-status-parse-fail     value 2.
               88  l-return-status-download-fail  value 3.
               88  l-return-status-url-invalid    value 4.

       procedure division 
           using l-feed-url
           returning l-download-and-parse-status.

       main-procedure.
           
           call "logger" using 
               function concatenate("URL passed to downloader: ", 
               l-feed-url)
           end-call

      *> No where near perfect... but will at least somewhat check if url.
           if l-feed-url(1:4) = "http" or "HTTP" then               
               move l-feed-url to ls-rss-feed-url
               perform download-rss-feed               
               if ls-download-status is zero then
                   call "logger" using 
                       "Download complete. Attempting to parse data"
                   end-call

                   move function rss-parser(
                       ws-rss-temp-filename, ls-rss-feed-url)
                       to ls-parse-status
                       
                   if ls-parse-status = 1 then 
                       call "logger" using "Parsing success."
                       set l-return-status-success to true 
                   else 
                       call "logger" using function concatenate(
                           "Parse failure. Parse Status code:",
                           ls-parse-status)
                       end-call 
                       set l-return-status-parse-fail to true 
                       goback 
                   end-if 
                   
               else 

                   call "logger" using function concatenate(
                       "Error downloading RSS feed. Status: ",
                       ls-download-status)
                   end-call
                   set l-return-status-download-fail to true 
               end-if
           else 
               call "logger" 
                   using "Cannot download RSS Feed. Url is invalid." 
               end-call
               set l-return-status-url-invalid to true 
           end-if           

           goback.


       download-rss-feed.
           
           call "logger" using 
               function concatenate(
               "Downloading RSS Feed: ", function trim(ls-rss-feed-url))
           end-call.

      *> Build WGET command...
           move function concatenate(
               ws-wget,
               function trim(ws-rss-temp-filename), SPACE,
               function trim(ls-rss-feed-url), SPACE)
           to ls-download-cmd

           call "logger" using function trim(ls-download-cmd)


      *> open pipe and execute download cmd.
           move pipe-open(ls-download-cmd, "r") to ws-pipe-record

           if ws-pipe-return not equal 255 then
               move pipe-close(ws-pipe-record) to ls-download-status
               if ls-download-status is zero then

                   call "logger" using function concatenate(
                       "Download success. Status=", ls-download-status)
                   end-call
               else
                   call "logger" using function concatenate(
                       "Error downloading RSS feed. Status=", 
                       ls-download-status)
                   end-call
               end-if
           end-if.

       end function rss-downloader.
