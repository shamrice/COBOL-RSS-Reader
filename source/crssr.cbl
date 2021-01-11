      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2020-11-05
      *> Last Updated: 2021-01-11
      *> Purpose: Application entry point
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************

       identification division.
       program-id. cobol-rss-reader.

       environment division.

       configuration section.

       repository.
           function get-config
           function rss-downloader
           function remove-rss-record.

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
           05  delete-feed-sw                  pic a value 'N'.
               88  is-delete-feed              value 'Y'.
               88  not-delete-feed             value 'N'.
           05  interactive-mode-sw             pic a value 'N'.
               88  is-interactive              value 'Y'.
               88  not-interactive             value 'N'.

       01  delete-rss-record.
           05  url-of-record                   pic x(256) value spaces.
           05  delete-status                   pic 9 value zero.

       77  cmd-args-buffer                     pic x(2048) value spaces.

       77  download-status                     pic 9 value zero.

       77  log-config-value                    pic x(16) value spaces.

       78  new-line                            value x"0a".
       78  log-enabled-switch                  value "==ENABLE-LOG==".
       78  log-disabled-switch                 value "==DISABLE-LOG==".

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

           perform set-logging-based-on-config


           if is-add-feed then 
               if cmd-args-buffer(4:4) not = "http" and "HTTP" then
                   display 
                       "Please enter url starting with http or https "
                       "and try again."
                   end-display
               else 
                   display 
                       "Downloading and parsing RSS feed: " 
                       function trim(cmd-args-buffer(4:))
                   end-display
                   move function rss-downloader(cmd-args-buffer(4:))
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
           end-if    

           if is-delete-feed then 
               move cmd-args-buffer(4:) to url-of-record
               display 
                   "Attempting to delete RSS feed: " 
                    function trim(url-of-record)
               end-display 
               
               move function remove-rss-record(url-of-record) 
                   to delete-status
               if delete-status = 1 then 
                   display "RSS Successfully deleted from feed list."
               else 
                   display 
                       "Failed to delete url from feed list. "
                       "Please check logs. Delete status: " 
                       delete-status
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

      * If add flag is specified.
           if cmd-args-buffer(1:2) = "-a" then 
               set is-valid-param to true 
               set is-add-feed to true 
               exit paragraph      
           end-if

      * If delete flag is specified.
           if cmd-args-buffer(1:2) = "-d" then 
               set is-valid-param to true 
               set is-delete-feed to true 
               exit paragraph
           end-if

      * If user specifies to not refresh feeds at start, set flag.
           if cmd-args-buffer(1:12) = "--no-refresh" then
               display "Not refreshing RSS Feeds."
               set is-valid-param to true 
               set not-refresh to true  
               set is-interactive to true  
               exit paragraph           
           end-if

      * Set logging based on logging param and start in interactive mode.
           if cmd-args-buffer(1:10) = "--logging=" then
               if cmd-args-buffer(11:5) not = "true" and "false" then 
                   exit paragraph 
               end-if 
               if cmd-args-buffer(11:4) = "true" then 
                   display "Logging is now enabled. Saving to config."
                   call "save-config" using "logging" "true"
               else
                   display "Logging is now disabled. Saving to config."
                   call "save-config" using "logging" "false"
               end-if
               set is-valid-param to true 
               set is-interactive to true 
               exit paragraph 
           end-if

           if cmd-args-buffer = spaces  then
               set is-valid-param to true 
               set is-interactive to true 
               display "Launching application in interactive mode..."
               exit paragraph
           end-if
           
           exit paragraph.



       set-logging-based-on-config.

      * Enable / disable logging based on config.    
           move function get-config("logging") to log-config-value
           if log-config-value = "true" then 
               display "Logging is enabled in config. Turning on."
               call "logger" using log-enabled-switch
           else 
               display "Logging disabled in config. Turning off."
               call "logger" using log-disabled-switch
           end-if

           exit paragraph.


       print-help.

           display
               "CRSSR is a console RSS reader application written in "
               "COBOL." new-line new-line
               "Usage:" new-line
               "  crssr                       Start interactive " 
               "mode and refresh feeds." new-line
               "  crssr --no-refesh           Start interactive "
               "mode without refreshing feeds" new-line
               "  crssr --logging=true        Start interactive "
               "mode and enables logging." new-line
               "  crssr --logging=false       Start interactive "
               "mode and disables logging." new-line
               "  crssr -a [url of rss feed]  Add a new RSS feed "
               "to RSS feed list."
               new-line
               "  crssr -d [url of rss feed]  Delete an existing "
               "RSS feed from list." new-line 
               new-line  
           end-display

           exit paragraph.

       end program cobol-rss-reader.
