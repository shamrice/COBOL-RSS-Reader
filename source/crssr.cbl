      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2020-11-05
      *> Last Updated: 2021-01-02
      *> Purpose: Application entry point
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************

       identification division.
       program-id. cobol-rss-reader.

       environment division.

       configuration section.

       repository.
           function rss-downloader.

       data division.

       working-storage section.

       01  parsed-cmd-params.
           05  valid-param-sw                  pic a value 'N'.
               88  is-valid-param              value 'Y'.
               88  not-valid-param             value 'N'.
           05  refresh-feed-sw                 pic a value 'Y'.
               88  is-refresh                  value 'Y'.
               88  not-refresh                 value 'N'.
           05  add-feed-sw                     pic a value 'N'.
               88  is-add-feed                 value 'Y'.
               88  not-add-feed                value 'N'.
           05  interactive-mode-sw             pic a value 'N'.
               88  is-interactive              value 'Y'.
               88  not-interactive             value 'N'.

       77  cmd-args-buffer                     pic x(2048) value spaces.

       77  download-status                     pic 9 value zero.

       78  new-line                            value x"0a".

       78  program-version                     value __APP_VERSION.
       78  web-url value __SOURCE_URL.
       78  build-date                          value __BUILD_DATE.


       procedure division.

       main-procedure.

           display
               new-line "COBOL RSS Reader " program-version new-line
               "-----------------------------------------------" 
               new-line "By: Erik Eriksen"
               new-line "Web: " web-url
               new-line "Build Date: " build-date new-line 
           end-display

           accept cmd-args-buffer from command-line 
           perform parse-cmd-args
          

           if is-add-feed then 
               display 
                   "Downloading and parsing RSS feed: " 
                   function trim(cmd-args-buffer)
               end-display
               move function rss-downloader(cmd-args-buffer)
                    to download-status
               if download-status = 1 then 
                   display "Downloading and parsing success."
               else 
                   display 
                       "Downloading and parsing failed. "
                       "Please check logs. Parse status: " 
                       download-status
                   end-display
               end-if    
           end-if    
  
           if is-interactive then 
               call "rss-reader-menu" using by content refresh-feed-sw
           end-if

           if not-valid-param then
               perform print-help
           end-if
     
           display "End program."
           stop run.


       parse-cmd-args.

      *> No where near perfect... but will at least check if user has some url in their input.
           if cmd-args-buffer(1:4) = "http" or "HTTP" then
               move 'Y' to valid-param-sw
               move 'Y' to add-feed-sw
               exit paragraph      
           end-if

      * If user specifies to not refresh feeds at start, set flag.
           if cmd-args-buffer(1:12) = "--no-refresh" then
               display "Not refreshing RSS Feeds."
               move 'Y' to valid-param-sw 
               move 'N' to refresh-feed-sw 
               move 'Y' to interactive-mode-sw
               exit paragraph           
           end-if

           if cmd-args-buffer = spaces  then
               move 'Y' to valid-param-sw
               move 'Y' to interactive-mode-sw
               display "Launching application in interactive mode..."
               exit paragraph
           end-if
           
           exit paragraph.

       print-help.

           display
               "CRSSR is a console RSS reader application written in "
               "COBOL." new-line new-line
               "Add new feed:" new-line
               "  Usage: crssr [url of rss feed]" new-line new-line
               "Start interactive mode without refreshing feeds:"
               new-line 
               "  Usage: crssr --no-refresh" new-line new-line
               "Run application with no arguments to start application "
               "in interactive mode and refresh feeds." new-line
               new-line  
           end-display

           exit paragraph.

       end program cobol-rss-reader.
