      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2020-12-21
      *> Last Updated: 2020-12-27
      *> Purpose: Downloads given RSS feed url and calls rss_parser
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************

       replace ==:BUFFER-SIZE:== by ==32768==.

       identification division.
       program-id. rss-downloader.

       environment division.

       configuration section.

       repository.
           function pipe-open
           function pipe-read
           function pipe-write
           function pipe-close
           function pinpoint
           function entrammel
           function cmove
           function all intrinsic.


       data division.

       working-storage section.

       01 raw-buffer                  pic x(:BUFFER-SIZE:) value spaces.


      *> a file pointer
       01 pipe-record.
           05 pipe-pointer                     usage pointer.
           05 pipe-return                      usage binary-long.


       77 download-cmd                         pic x(:BUFFER-SIZE:).
       77 download-status                      pic 9 value 9.

       77 rss-feed-url                         pic x(256) value spaces.
       77 rss-temp-filename                    pic x(255)
                                               value "./feeds/temp.rss".

       78 new-line                             value x"0a".
       78 wget                                 value "wget -q -O ".

      

       linkage section.
           01 ls-feed-url                      pic x(256).

       procedure division using ls-feed-url.

       main-procedure.

           move spaces to download-cmd
           move spaces to rss-feed-url
           move 9 to download-status
           move spaces to raw-buffer
           
           call "logger" using 
               function concatenate("URL passed to downloader: ", 
               ls-feed-url)
           end-call

      *> No where near perfect... but will at least somewhat check if url.
           if ls-feed-url(1:4) = "http" or "HTTP" then               
               move ls-feed-url to rss-feed-url
               perform download-rss-feed               
               if download-status is zero then
                   call "logger" using 
                       "Download complete. Attempting to parse data"
                   end-call
                   call "rss-parser" 
                       using by content rss-temp-filename rss-feed-url
                   end-call
               else 

                   call "logger" using function concatenate(
                       "Error downloading RSS feed. Status: ",
                       download-status new-line)
                   end-call
               end-if
           else 
               call "logger" 
                   using "Cannot download RSS Feed. Url is invalid." 
               end-call
           end-if           

           goback.


       download-rss-feed.
           
           call "logger" using 
               function concatenate(
               "Downloading RSS Feed: ", function trim(rss-feed-url))
           end-call.

      *> Build WGET command...
           move function concatenate(
               wget,
               function trim(rss-temp-filename), SPACE,
               function trim(rss-feed-url), SPACE)
           to download-cmd

           call "logger" using function trim(download-cmd)


      *> open pipe and execute download cmd.
           move pipe-open(download-cmd, "r") to pipe-record

           if pipe-return not equal 255 then
               move pipe-close(pipe-record) to download-status
               if download-status is zero then

                   call "logger" using function concatenate(
                       "Download success. Status=", download-status)
                   end-call
               else
                   call "logger" using function concatenate(
                       "Error downloading RSS feed. Status=", 
                       download-status)
                   end-call
               end-if
           end-if.

       end program rss-downloader.
