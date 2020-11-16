      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2020-11-05
      *> Last Updated: 2020-11-11
      *> Purpose: Application entry point
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************

       replace ==:BUFFER-SIZE:== by ==32768==.

       identification division.
       program-id. cobol-rss-reader.

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

       01 raw-buffer                           pic x(:BUFFER-SIZE:).

       01 command-arguments                    pic x(2048) value spaces.

      *> a file pointer
       01 pipe-record.
           05 pipe-pointer                     usage pointer.
           05 pipe-return                      usage binary-long.


       77 download-cmd                         pic x(:BUFFER-SIZE:).
       77 download-status                      pic 9 value 9.

       77 rss-feed-url                         pic x(2048).
       77 rss-temp-filename                    pic x(255)
                                               value "./feeds/temp.rss".

       77 is-valid-param                       pic a value 'N'.

       78 new-line                              value x"0a".
       78 program-version                      value 0.04.

       78 wget                                 value "wget -O ".


       procedure division.


       main-procedure.

           display
               new-line "COBOL RSS Reader v" program-version new-line
               "-----------------------------------------------"
           end-display

           accept command-arguments from command-line end-accept

      *> No where near perfect... but will at least check if user has some url in their input.
           if command-arguments(1:4) = "http" or "HTTP" then
               move 'Y' to is-valid-param
               perform download-rss-feed
               if download-status is zero then
                   call "rss-parser" using by content rss-temp-filename
               end-if
           end-if

           if command-arguments = spaces then
               move 'Y' to is-valid-param
               call "rss-reader-menu"
           end-if

           if is-valid-param = 'N' then
               perform print-help
           end-if

      *> TODO : No args should display current rss feed.
           stop run.


       download-rss-feed.

           move command-arguments to rss-feed-url

           display
               "Downloading RSS Feed: " function trim(rss-feed-url)
               new-line
           end-display.

      *> Build WGET command...
           move function concatenate(
               wget,
               function trim(rss-temp-filename), SPACE,
               function trim(rss-feed-url), SPACE)
           to download-cmd

           display function trim(download-cmd)


      *> open pipe and execute download cmd.
           move pipe-open(download-cmd, "r") to pipe-record

           if pipe-return not equal 255 then
               move pipe-close(pipe-record) to download-status
               if download-status is zero then
                   display "Download success. Status=" download-status
               else
                   display
                   new-line
                   "Error downloading RSS feed. Status=" download-status
                   end-display
               end-if
           end-if.


       print-help.

           display
               "CRSSR is a command line RSS reader written in COBOL."
               new-line new-line
               "Usage: crssr [url of rss feed]" new-line
           end-display.



       end program cobol-rss-reader.
