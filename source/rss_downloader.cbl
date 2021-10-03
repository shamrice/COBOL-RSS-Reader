      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2020-12-21
      *> Last Updated: 2021-09-29
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
           function get-config 
           function pipe-open
           function pipe-close
           function rss-parser.

       input-output section.
           file-control.           
               copy "./copybooks/filecontrol/rss_list_file.cpy".

       data division.

       file section.
           copy "./copybooks/filedescriptor/fd_rss_list_file.cpy".

       working-storage section.

      *> a file pointer
       01  ws-pipe-record.
           05  ws-pipe-pointer                usage pointer.
           05  ws-pipe-return                 usage binary-long.

       01  ws-download-cmd-start              pic x(32).

       01  ws-xmllint-cmd                     pic x(32). 

       77  ws-rss-temp-filename               pic x(255)
                                              value "./feeds/temp.rss".
      
       77  ws-rss-temp-filename-retry         pic x(255)
                                              value "./feeds/temp1.rss".
       
       78  ws-rss-list-file-name             value "./feeds/list.dat".

      
       local-storage section.
       

       77  ls-download-cmd                    pic x(:BUFFER-SIZE:).

       77  ls-xmllint-cmd-full                pic x(:BUFFER-SIZE:).

       77  ls-rss-feed-url                    pic x(256) value spaces.

       77  ls-download-status                 pic 9 value 9.

       77  ls-parse-status                    pic S9 value 0.

       77  ls-format-status                   pic 9 value 0.

       77  ls-url-prefix                      pic x(4).

       77  ls-download-parse-status-temp      pic 9 value 0.

       linkage section.
           01  l-feed-url                         pic x(256).

           01  l-download-and-parse-status        pic 9 value zero.
               88  l-return-status-success        value 1.
               88  l-return-status-parse-fail     value 2.
               88  l-return-status-download-fail  value 3.
               88  l-return-status-url-invalid    value 4.
               88  l-return-status-format-fail    value 5.

       procedure division 
           using l-feed-url
           returning l-download-and-parse-status.

       main-procedure.
           
           call "logger" using 
               function concatenate("URL passed to downloader: ", 
               l-feed-url)
           end-call

      *> No where near perfect... but will at least somewhat check if url.
           move function lower-case(l-feed-url(1:4)) to ls-url-prefix
           if ls-url-prefix not = "http" then               
               call "logger" 
                   using "Cannot download RSS Feed. Url is invalid." 
               end-call
               set l-return-status-url-invalid to true 
               goback 
           end-if 

           move l-feed-url to ls-rss-feed-url
           perform download-rss-feed   


           if ls-download-status is not zero then
               call "logger" using function concatenate(
                   "Error downloading RSS feed. Status: ",
                   ls-download-status)
               end-call
               set l-return-status-download-fail to true

           else
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

               *> If failed, check to see if xmllint is enabled, and if so reparse.
                   perform xmllint-and-reparse-temp-file

               end-if                                                 
           end-if

           perform save-rss-feed-status

           goback.


       download-rss-feed.
           
           call "logger" using 
               function concatenate(
               "Downloading RSS Feed: ", function trim(ls-rss-feed-url))
           end-call.

           move function get-config("down_cmd") to ws-download-cmd-start

      *> Build WGET/CURL download command...
           move function concatenate(
               function trim(ws-download-cmd-start), SPACE, 
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
           end-if

           exit paragraph.



       xmllint-and-reparse-temp-file.

           move function get-config("xmllint") to ws-xmllint-cmd

           if ws-xmllint-cmd = "NOT-SET" then 
               call "logger" using function concatenate(
                   "Xmllint is not configured. Not attempting to format"
                   " and reparse downloaded file.")
               end-call 
               exit paragraph
           end-if 

      *> Build xmllint command...
           move function concatenate(
               ws-xmllint-cmd,
               function trim(ws-rss-temp-filename),  
               " > ", function trim(ws-rss-temp-filename-retry))
           to ls-xmllint-cmd-full

           call "logger" using function trim(ls-xmllint-cmd-full)

           move zero to ls-format-status
           move zero to ws-pipe-return

      *> open pipe and execute xmllint format cmd.
           move pipe-open(ls-xmllint-cmd-full, "r") to ws-pipe-record

           if ws-pipe-return = 255 then
               call "logger" using function concatenate(
                   "Failed to open xmllint format command: " 
                   ls-xmllint-cmd-full)
               end-call 
               set l-return-status-format-fail to true 
               
               exit paragraph 
           end-if 

           move pipe-close(ws-pipe-record) to ls-format-status
           if ls-format-status is not zero then
               call "logger" using function concatenate(
                   "Error formatting RSS feed. Status=", 
                   ls-format-status)
               end-call
               set l-return-status-format-fail to true 

               exit paragraph
           end-if 


           call "logger" using function concatenate(
               "Format success. Status=", ls-format-status, 
               " : Attempting to reparse file.")
           end-call
           
           move function rss-parser(
               ws-rss-temp-filename-retry, ls-rss-feed-url)
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
           end-if          

           exit paragraph.


      *> Save latest download and parse status to the list index file
      *> for the feed.
       save-rss-feed-status.

           move ls-rss-feed-url to f-rss-link 
           move l-download-and-parse-status 
               to ls-download-parse-status-temp

           open i-o fd-rss-list-file 
           
               read fd-rss-list-file
                   invalid key 
                       call "logger" using function concatenate( 
                           "No RSS list record to update for key: "
                           ls-rss-feed-url)
                       end-call 
                       close fd-rss-list-file
                       exit paragraph                   
               end-read 

               move ls-download-parse-status-temp to f-rss-feed-status 

               rewrite f-rss-list-record 
                   invalid key 
                       call "logger" using function concatenate(
                           "Unable to save RSS feed status: " 
                           ls-download-parse-status-temp
                           ". Key is invalid: " 
                           ls-rss-feed-url)
                       end-call
                   not invalid key 
                       call "logger" using function concatenate(
                           "Successfully updated RSS feed status: "
                           ls-download-parse-status-temp
                           " for RSS list key: " 
                           ls-rss-feed-url)
                       end-call 
               end-rewrite

           close fd-rss-list-file 
           exit paragraph.

       end function rss-downloader.
