      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-10
      * Last Modified: 2021-01-12
      * Purpose: RSS Reader Help - Screen sub program to show help
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-help.

       environment division.
       
       configuration section.

       repository.

       special-names.
           crt status is ws-crt-status.

       input-output section.

       data division.
       file section.

       working-storage section.

       copy "screenio.cpy".

       01  ws-crt-status. 
           05  ws-key1                       pic x. 
           05  ws-key2                       pic x. 
           05  filler                        pic x. 
           05  filler                        pic x.

      * Strings to display on help screen.
       01  ws-display-text                   occurs 18 times.
           05  ws-help-text                  pic x(78) value spaces. 


       01  ws-accept                         pic x.

       01  ws-page-num                       pic 9 value 1.

       01  ws-exit-sw                        pic a value 'N'.
           88  ws-exit-true                  value 'Y'.
           88  ws-exit-false                 value 'N'.

       77  empty-line                        pic x(80) value spaces. 

       78  ws-program-version                value __APP_VERSION.
       78  ws-web-url 
               value __SOURCE_URL.
       78  ws-build-date                     value __BUILD_DATE.

       linkage section.

       screen section.
       
       copy "./screens/blank_screen.cpy".
       copy "./screens/rss_help_screen.cpy".

       procedure division.
       set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
       set environment 'COB_SCREEN_ESC'        TO 'Y'.
      
       main-procedure.

           perform set-page-text 

           display s-blank-screen
           perform handle-user-input

           display s-blank-screen 
           goback.


       handle-user-input.

           perform until ws-exit-true

               accept s-rss-help-screen 

               evaluate true 
                      
                   when ws-key1 = COB-SCR-OK
                       add 1 to ws-page-num
                       perform set-page-text
                        
                   
                   when ws-crt-status = COB-SCR-ESC
                       set ws-exit-true to true 
                       
               end-evaluate
           end-perform

           exit paragraph.



       set-page-text.
           evaluate true

               when ws-page-num = 1  
                   perform set-page-1-text

               when ws-page-num = 2
                   perform set-page-2-text

               when ws-page-num = 3
                   perform set-page-3-text 

               when ws-page-num = 4
                   perform set-page-4-text

               when ws-page-num = 5
                   perform set-page-5-text

               when other
                   set ws-exit-true to true 

           end-evaluate

           exit paragraph.



       set-page-1-text.

           move 
           "Adding a new RSS feed:" to ws-display-text(1)
           move function concatenate(
           "  RSS feeds can be added by either the '-a' command line ",
           "parameter or") to ws-display-text(2)
           move function concatenate(
           "  through the add feed option off the main menu by ",
           "pressing F3.") to ws-display-text(3)
           move 
           "  URLs should start with either HTTP or HTTPS."
               to ws-display-text(4)
           move spaces to ws-display-text(5)
           move
           "Add feed command line example:" to ws-display-text(6) 
           move "  crssr -a https://www.example.com/feed.rss" 
               to ws-display-text(7)
           move spaces to ws-display-text(8) 
           move spaces to ws-display-text(9) 
           move "Deleting existing RSS feed:" to ws-display-text(10) 
           move function concatenate(
           "  RSS feeds can be removed similiar to how they can be ",
           "added. The"
           ) to ws-display-text(11) 
           move function concatenate(
           "  '-d' command line parameter or the delete feed option ",
           "off the menu") to ws-display-text(12)
           move "  by pressing F4 can be used to perform this action." 
               to ws-display-text(13)
           move function concatenate(
           "  When using the F4 menu option, the feed that the cursor",
           " is currently") to ws-display-text(14)
           move function concatenate(
           "  positioned at will deleted after accepting the ",
           "confirmation dialog.") to ws-display-text(15)
           move spaces to ws-display-text(16)
           move function concatenate(
           "  When using the command line option, the RSS feed URL ",
           "needs to be provided") to ws-display-text(17)
           move spaces to ws-display-text(18)

           exit paragraph.

       
       set-page-2-text.
           move "Delete feed command line example:" 
               to ws-display-text(1)
           move 
           "  crssr -d https://www.example.com/feed.rss"
           to ws-display-text(2)
           move spaces to ws-display-text(3)
           move spaces to ws-display-text(4)
           move "Viewing a feed:" to ws-display-text(5)
           move function concatenate(
           "  Feeds that have been added to the RSS list can be viewed",
           " by moving the") to ws-display-text(6) 
           move function concatenate(
           "  cursor with the Arrow keys or Tab key to the desired ",
           "feed and then") to ws-display-text(7) 
           move function concatenate(
           "  pressing the Enter key. This will open another list with",
           " all the ") to ws-display-text(8) 
           move "  feed items for the selected feed."
               to ws-display-text(9) 
           move spaces to ws-display-text(10) 
           move spaces to ws-display-text(11) 
           move "Viewing feed items:" to ws-display-text(12)
           move function concatenate(
           "  Feed items for a selected feed can be viewed the same as",
           " the feed itself") to ws-display-text(13) 
           move function concatenate(
           "  can be viewed. The Arrow keys or Tab key select the ",
           " item and Enter") to ws-display-text(14) 
           move "  opens it up to be viewed." to ws-display-text(15) 
           move spaces to ws-display-text(16)
           move spaces to ws-display-text(17)
           move spaces to ws-display-text(18)

           exit paragraph.

       set-page-3-text.

           move function concatenate(
           "  When viewing an item, you can open the item link URL in ",
           "the Lynx browser") to ws-display-text(1) 
           move function concatenate(
           "  if it is installed on your system by pressing the Enter ",
           "key. Once") to ws-display-text(2) 
           move function concatenate(
           "  the browser is exited, you will be returned back to the ",
           "item screen") to ws-display-text(3) 
           move "  where the browser was launched from. "
               to ws-display-text(4)
           move spaces to ws-display-text(5) 
           move "Exiting a screen:" to ws-display-text(6)
           move function concatenate(
           "  The Esc key can be used to return to the previous ",
           "screen from") to ws-display-text(7) 
           move function concatenate(
           "  any dialog screen or sub screen. To exit the main menu, ",
           "press F10") to ws-display-text(8) 
           move spaces to ws-display-text(9) 
           move "Logging" to ws-display-text(10) 
           move function concatenate(
           "  Log files are generated when running the application. ",
           "These files can") to ws-display-text(11) 
           move function concatenate(
           "  help you pinpoint any errors if needed or just give an ",
           "idea what was done") to ws-display-text(12)
           move "  while you were using the application." 
               to ws-display-text(13)
           move spaces to ws-display-text(14)
           move "The log file name uses the following format:"
               to ws-display-text(15) 
           move "  crssr_YYYYMMDD.log" to ws-display-text(16)
           move spaces to ws-display-text(17)
           move spaces to ws-display-text(18)  
       
           exit paragraph.


       set-page-4-text.

           move function concatenate(
           "  The date in the file name will roll over to the next ",
           "day automatically") to ws-display-text(1)
           move spaces to ws-display-text(2)
           move function concatenate(
           "  Logging by default is turned off when not set in the ",
           "configuration file.") to ws-display-text(3) 
           move function concatenate(
           "  It can be turned on and off using the following command ",
           "line parameters.") to ws-display-text(4) 
           move spaces to ws-display-text(5)
           move "Turn on logging:" to ws-display-text(6) 
           move "  crssr --logging=true" to ws-display-text(7) 
           move spaces to ws-display-text(8) 
           move "Turn off logging:" to ws-display-text(9) 
           move "  crssr --logging=false" to ws-display-text(10)
           move spaces to ws-display-text(11)
           move function concatenate(
           "NOTE: These values will persist until the config ",
           "file is updated using") to ws-display-text(12) 
           move function concatenate(
           "      the command line parameter or the configuration file",
           " is deleted.")to ws-display-text(13)  
           move spaces to ws-display-text(14)  
           move spaces to ws-display-text(15)  
           move spaces to ws-display-text(16)  
           move spaces to ws-display-text(17)  
           move spaces to ws-display-text(18)  
       
           exit paragraph.


       set-page-5-text.
           move spaces to ws-display-text(1) 
           move "About:" to ws-display-text(2) 
           move "        By: Erik Eriksen" to ws-display-text(3) 
           move function concatenate(
                "   Version: ", ws-program-version) 
                to ws-display-text(4) 
           move function concatenate(
               "Build Date: ", ws-build-date) to ws-display-text(5) 
           move spaces to ws-display-text(6) 
           move spaces to ws-display-text(7) 
           move function concatenate(
           " If you would like to check for any updates or would like ",
           "to report any bugs") to ws-display-text(8) 
           move " please do so at the following URL:" 
               to ws-display-text(9)
           move spaces to ws-display-text(10) 
           move function concatenate(
           " ", ws-web-url) to ws-display-text(11)
           move spaces to ws-display-text(12)
           move spaces to ws-display-text(13)
           move spaces to ws-display-text(14)
           move spaces to ws-display-text(15)
           move spaces to ws-display-text(16)
           move spaces to ws-display-text(17)
           move spaces to ws-display-text(18)

           exit paragraph.
       end program rss-reader-help.
