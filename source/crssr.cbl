      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2020-11-05
      *> Last Updated: 2020-11-07
      *> Purpose: Application entry point
      *> Tectonics:
      *>     ./build.sh
      *> or: cobc -x crssr.cbl rss_parser.cbl rss_reader.cbl cobweb-pipes.cob -o crssr
      *> or: cobc -x -DWIN_NO_POSIX crssr.cbl rss_reader.cbl cobweb-pipes.cob -g -debug
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

       78 newline                              value x"0a".
       78 program-version                      value 0.01.

       78 wget                                 value "wget -O ".


       procedure division.


       main-procedure.

           display
               newline "COBOL RSS Reader v" program-version newline
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
               call "rss-reader"
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
               newline
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
                   newline
                   "Error downloading RSS feed. Status=" download-status
                   end-display
               end-if
           end-if.


       print-help.

           display
               "CRSSR is a command line RSS reader written in COBOL."
               newline newline
               "Usage: crssr [url of rss feed]" newline
           end-display.



       end program cobol-rss-reader.
