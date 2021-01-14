      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2020-11-05
      *> Last Updated: 2021-01-14
      *> Purpose: Application entry point
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************

       identification division.
       program-id. cobol-rss-reader.

       environment division.

       configuration section.

       repository.
           function rss-report-writer
           function get-config
           function rss-downloader
           function remove-rss-record.

       data division.

       working-storage section.

       01  ws-parsed-cmd-params.
           05  ws-valid-param-sw                  pic a value 'N'.
               88  ws-is-valid-param              value 'Y'.
               88  ws-not-valid-param             value 'N'.
           05  ws-refresh-feed-sw                 pic a value 'Y'.
               88  ws-is-refresh                  value 'Y'.
               88  ws-not-refresh                 value 'N'.
           05  ws-add-feed-sw                     pic a value 'N'.
               88  ws-is-add-feed                 value 'Y'.
               88  ws-not-add-feed                value 'N'.
           05  ws-delete-feed-sw                  pic a value 'N'.
               88  ws-is-delete-feed              value 'Y'.
               88  ws-not-delete-feed             value 'N'.
           05  ws-report-sw                       pic a value 'N'.
               88  ws-is-report                   value 'Y'.
               88  ws-not-report                  value 'N'.
           05  ws-interactive-mode-sw             pic a value 'N'.
               88  ws-is-interactive              value 'Y'.
               88  ws-not-interactive             value 'N'.           

       01  ws-report-args.
           05  ws-report-name                  pic x(512) value spaces.
           05  ws-report-url                   pic x(256) value spaces.
           05  ws-report-status                pic 9 value zero.

       01  ws-delete-rss-record.
           05  ws-url-of-record                pic x(256) value spaces.
           05  ws-delete-status                pic 9 value zero.

       77  ws-cmd-args-buffer                  pic x(2048) value spaces.

       77  ws-download-status                  pic 9 value zero.

       77  ws-log-config-value                 pic x(16) value spaces.

       78  ws-new-line                         value x"0a".
       78  ws-log-enabled-switch               value "==ENABLE-LOG==".
       78  ws-log-disabled-switch              value "==DISABLE-LOG==".

       78  ws-program-version                  value __APP_VERSION.
       78  ws-web-url 
               value __SOURCE_URL.
       78  ws-build-date                       value __BUILD_DATE.

       procedure division.

       main-procedure.

           display
               ws-new-line "COBOL RSS Reader " ws-program-version 
               ws-new-line
               "-----------------------------------------------" 
               ws-new-line "By: Erik Eriksen"
               ws-new-line "Web: " ws-web-url
               ws-new-line "Build Date: " ws-build-date ws-new-line 
           end-display

           accept ws-cmd-args-buffer from command-line 
           perform parse-cmd-args

           if ws-not-valid-param then
               perform print-help
               stop run 
           end-if
     
           perform set-logging-based-on-config

           if ws-is-add-feed then 
               if ws-cmd-args-buffer(4:4) not = "http" and "HTTP" then
                   display 
                       "Please enter url starting with http or https "
                       "and try again."
                   end-display
               else 
                   display 
                       "Downloading and parsing RSS feed: " 
                       function trim(ws-cmd-args-buffer(4:))
                   end-display
                   move function rss-downloader(ws-cmd-args-buffer(4:))
                       to ws-download-status
                   if ws-download-status = 1 then 
                       display "Downloading and parsing success."
                   else 
                       display 
                           "Downloading and parsing failed. "
                           "Please check logs. Parse status: " 
                           ws-download-status
                       end-display
                   end-if
               end-if    
           end-if    

           if ws-is-delete-feed then 
               move ws-cmd-args-buffer(4:) to ws-url-of-record
               display 
                   "Attempting to delete RSS feed: " 
                    function trim(ws-url-of-record)
               end-display 
               
               move function remove-rss-record(ws-url-of-record) 
                   to ws-delete-status
               if ws-delete-status = 1 then 
                   display "RSS Successfully deleted from feed list."
               else 
                   display 
                       "Failed to delete url from feed list. "
                       "Please check logs. Delete status: " 
                       ws-delete-status
                   end-display
               end-if 
           end-if

           if ws-is-report then 
               if ws-report-url(1:4) not = "http" and "HTTP" then 
                   display 
                       "Please enter a RSS feed URL starting with HTTP "
                       "or HTTPS and try again."
                   end-display 
               else
                   display 
                       "Attempting to generate report for RSS URL: "
                       function trim(ws-report-url) ws-new-line
                       "Output file: " function trim(ws-report-name)
                   end-display 
                   move function rss-report-writer(
                       ws-report-url, ws-report-name) 
                       to ws-report-status
                   if ws-report-status = 1 then 
                       display "Report created successfully."
                   else 
                       display 
                           "Failed to generate report. Please check "
                           "logs and try again."
                       end-display 
                   end-if 
               end-if
           end-if

  
           if ws-is-interactive then 
               call "rss-reader-menu" 
                   using by content ws-refresh-feed-sw
               end-call
           end-if

           
           display "End program."
           stop run.


       parse-cmd-args.

      * If add flag is specified.
           if ws-cmd-args-buffer(1:2) = "-a" then 
               set ws-is-valid-param to true 
               set ws-is-add-feed to true 
               exit paragraph      
           end-if

      * If delete flag is specified.
           if ws-cmd-args-buffer(1:2) = "-d" then 
               set ws-is-valid-param to true 
               set ws-is-delete-feed to true 
               exit paragraph
           end-if

      * Set report flag and command arg variables.
           if ws-cmd-args-buffer(1:2) = "-r" then 
               unstring ws-cmd-args-buffer(4:) delimited by space 
                   into ws-report-name ws-report-url
               end-unstring
               set ws-is-valid-param to true 
               set ws-is-report to true
               exit paragraph
           end-if

      * If user specifies to not refresh feeds at start, set flag.
           if ws-cmd-args-buffer(1:12) = "--no-refresh" then
               display "Not refreshing RSS Feeds."
               set ws-is-valid-param to true 
               set ws-not-refresh to true  
               set ws-is-interactive to true  
               exit paragraph           
           end-if

      * Set logging based on logging param and start in interactive mode.
           if ws-cmd-args-buffer(1:10) = "--logging=" then
               if ws-cmd-args-buffer(11:5) not = "true" and "false" then 
                   exit paragraph 
               end-if 
               if ws-cmd-args-buffer(11:4) = "true" then 
                   display "Logging is now enabled. Saving to config."
                   call "save-config" using "logging" "true"
               else
                   display "Logging is now disabled. Saving to config."
                   call "save-config" using "logging" "false"
               end-if
               set ws-is-valid-param to true 
               set ws-is-interactive to true 
               exit paragraph 
           end-if

           if ws-cmd-args-buffer = spaces  then
               set ws-is-valid-param to true 
               set ws-is-interactive to true 
               display "Launching application in interactive mode..."
               exit paragraph
           end-if
           
           exit paragraph.



       set-logging-based-on-config.

      * Enable / disable logging based on config.    
           move function get-config("logging") to ws-log-config-value
           if ws-log-config-value = "true" then 
               display "Logging is enabled in config. Turning on."
               call "logger" using ws-log-enabled-switch
           else 
               display "Logging disabled in config. Turning off."
               call "logger" using ws-log-disabled-switch
           end-if

           exit paragraph.


       print-help.

           display
               "CRSSR is a console RSS reader application written in "
               "COBOL." ws-new-line ws-new-line
               "Usage:" ws-new-line
               "  crssr                       Start interactive " 
               "mode and refresh feeds." ws-new-line
               "  crssr --no-refesh           Start interactive "
               "mode without refreshing feeds" ws-new-line
               "  crssr --logging=true        Start interactive "
               "mode and enables logging." ws-new-line
               "  crssr --logging=false       Start interactive "
               "mode and disables logging." ws-new-line
               "  crssr -a [url of rss feed]  Add a new RSS feed "
               "to RSS feed list."
               ws-new-line
               "  crssr -d [url of rss feed]  Delete an existing "
               "RSS feed from list." ws-new-line 
               ws-new-line
               "  crssr -r [output filename] [url of rss feed] "                    
               ws-new-line
               "           Generate report for existing RSS feed "                   
               "to output file specified." 
               ws-new-line                  
           end-display

           exit paragraph.

       end program cobol-rss-reader.
