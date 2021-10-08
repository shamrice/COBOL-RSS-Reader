      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-10
      * Last Modified: 2021-10-08
      * Purpose: RSS Reader Help - Screen sub program to show help
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-help.

       environment division.
       
       configuration section.

       repository.

       special-names.
           cursor is ws-cursor-position 
           crt status is ws-crt-status.

       input-output section.

       data division.
       file section.

       working-storage section.

       copy "screenio.cpy".

       01  ws-cursor-position.
           05  ws-cursor-line                pic 99.
           05  ws-cursor-col                 pic 99.

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

       01  ws-last-page-sw                   pic a value 'N'.
           88  ws-last-page                  value 'Y'.
           88  ws-not-last-page              value 'N'.

       01  ws-next-page-text-colors.
           05  ws-next-page-cmd-fg-color     pic 9 value 0.
           05  ws-next-page-cmd-bg-color     pic 9 value 7.           
           05  ws-next-page-text-fg-color    pic 9 value 7.
           05  ws-next-page-text-bg-color    pic 9 value 0.

       01  ws-prev-page-text-colors.
           05  ws-prev-page-cmd-fg-color     pic 9 value 0.
           05  ws-prev-page-cmd-bg-color     pic 9 value 0.           
           05  ws-prev-page-text-fg-color    pic 9 value 0.
           05  ws-prev-page-text-bg-color    pic 9 value 0.           

       77  ws-empty-line                     pic x(80) value spaces. 

       78  ws-program-version                value __APP_VERSION.
       78  ws-web-url 
               value __SOURCE_URL.
       78  ws-build-date                     value __BUILD_DATE.

       linkage section.

       screen section.
              
       copy "./screens/rss_help_screen.cpy".

       procedure division.
       set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
       set environment 'COB_SCREEN_ESC'        TO 'Y'.
      
       main-procedure.

           perform set-page-text 

           display spaces blank screen 
           perform handle-user-input

           display spaces blank screen 
           goback.


       handle-user-input.

           perform until ws-exit-true

               accept s-rss-help-screen with auto-skip

               call "logger" using ws-crt-status

               evaluate true 
                      
                   when (ws-key1 = COB-SCR-OK 
                   or ws-crt-status = COB-SCR-PAGE-DOWN)
                   and ws-not-last-page
                       add 1 to ws-page-num
                       perform set-page-text
                        
                   when ws-crt-status = COB-SCR-PAGE-UP
                   and ws-page-num > 1
                       set ws-not-last-page to true 
                       subtract 1 from ws-page-num
                       perform set-page-text

                   when ws-crt-status = COB-SCR-ESC
                       set ws-exit-true to true                        

      *>   Mouse input handling.                   
                   when ws-crt-status = COB-SCR-LEFT-RELEASED
                       perform handle-mouse-click                   


               end-evaluate
           end-perform

           exit paragraph.


       handle-mouse-click.
           if ws-cursor-line = 21 then 
               evaluate true 
                   when ws-cursor-col >= 4 and ws-cursor-col < 25
                   and ws-page-num > 1 
                       subtract 1 from ws-page-num
                       perform set-page-text

                   when ws-cursor-col >= 26 and ws-cursor-col < 49
                   and ws-not-last-page
                       add 1 to ws-page-num 
                       perform set-page-text 
                   
                   when ws-cursor-col >= 50 and ws-cursor-col < 74 
                       set ws-exit-true to true 
               end-evaluate
           end-if 

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

               when ws-page-num = 6
                   perform set-page-6-text

               when ws-page-num = 7
                   perform set-page-7-text

               when ws-page-num = 8
                   perform set-page-8-text                   

               when other
                   set ws-exit-true to true 

           end-evaluate

           if ws-not-last-page then 
               move cob-color-white to ws-next-page-cmd-bg-color
               move cob-color-black to ws-next-page-cmd-fg-color
               move cob-color-white to ws-next-page-text-fg-color
               move cob-color-black to ws-next-page-text-bg-color
           else 
               move zeros to ws-next-page-text-colors
           end-if   

           if ws-page-num > 1 then 
               move cob-color-white to ws-prev-page-cmd-bg-color
               move cob-color-black to ws-prev-page-cmd-fg-color
               move cob-color-white to ws-prev-page-text-fg-color
               move cob-color-black to ws-prev-page-text-bg-color
           else 
               move zeros to ws-prev-page-text-colors
           end-if   


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
           "the currently") to ws-display-text(1) 
           move function concatenate(
           "  configured browser (Lynx or Links) by pressing the Enter "
           "key. ") to ws-display-text(2) 
           move function concatenate(
           "  If neither of these browsers are installed, this option "
           "will not be") to ws-display-text(3) 
           move function concatenate(
           "  available. If Xterm is installed, it will open in a new "
           "terminal window.") to ws-display-text(4)
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
           move function concatenate(
           "NOTE: These values will persist until the config ",
           "file is updated using") to ws-display-text(11) 
           move function concatenate(
           "      the command line parameter or the configuration file",
           " is deleted.")to ws-display-text(12)  
           move spaces to ws-display-text(13)  
           move "Refreshing Feeds:" to ws-display-text(14)  
           move function concatenate(
           "  All current feeds will be refreshed at start up unless ",
           'the "--no-refresh" ') to ws-display-text(15)  
           move function concatenate(
           "  command line parameter is specified. This can also be ",
           "done by pressing F5") to ws-display-text(16)  
           move "  on the main feed menu." to ws-display-text(17)  
           move spaces to ws-display-text(18)
           
           exit paragraph.


       set-page-5-text.

           move function concatenate(
           "  Refreshing feeds will download the latest RSS feed ",
           "data and parse its") to ws-display-text(1)
           move function concatenate(
           "  contents into data files in the feeds directory for each",
           " feed in the feed") to ws-display-text(2)
           move "  list." to ws-display-text(3) 
           move spaces to ws-display-text(4) 
           move "Export Feed:" to ws-display-text(5) 
           move function concatenate(
           "  Feeds can be exported to an output file either through ",
           "a command parameter") to ws-display-text(6)
           move function concatenate(
           "  or by pressing F8 on the main feed menu. When exporting ",
           "by using F8,") to ws-display-text(7)
           move function concatenate(
           "  you will be prompted for a file name to export to for ",
           "the feed the") to ws-display-text(8) 
           move "  cursor is positioned on." to ws-display-text(9)
           move spaces to ws-display-text(10) 
           move "Export feed URL to a file:" to ws-display-text(11)
           move "  crssr -o [output file name] [feed url to export]" 
               to ws-display-text(12)
           move spaces to ws-display-text(13)
           move spaces to ws-display-text(14)
           move "Configuration" to ws-display-text(15)           
           move function concatenate(
           "  The configuration screen can be accessed by pressing the " 
           "F9 button on the") to ws-display-text(16)
           move function concatenate(
           "  main feed menu. To change settings, place an 'x' next to "
           " the options") to ws-display-text(17)
           move spaces to ws-display-text(18)

           exit paragraph.

       set-page-6-text.
           move function concatenate(
           "  you would like to set. Once these values are set, press "
           "the Enter key to") to ws-display-text(1)
           move function concatenate(
           "  save the selected values. The F5 key can be used to auto "
           "configure settings.") to ws-display-text(2)
           move spaces to ws-display-text(3)
           move function concatenate(
           "  Note: Manually changing settings will turn off auto "
           "configuration at") to ws-display-text(4) 
           move 
           "        start up until auto configuration is re-ran."
           to ws-display-text(5)
           move spaces to ws-display-text(6)
           move "Auto Configuration" to ws-display-text(7)
           move function concatenate(
           "  Running auto configuration via the command line option"
           " --auto-configure") to ws-display-text(8)
           move function concatenate( 
           "  or through the configuration screen will attempt to set "
           "the configuration") to ws-display-text(9)
           move function concatenate( 
           "  values based on what is currently installed on your "
           "computer. This process")
               to ws-display-text(10)
           move function concatenate(
           "  will run at every application start up until a "
           "configuration value is") to ws-display-text(11)
           move function concatenate(
           "  manually changed on the configuration screen. It is also "
           "ran by default in") to ws-display-text(12)
           move function concatenate( 
           "  the case where no configuration file currently  exists.")
           to ws-display-text(13)
           move spaces to ws-display-text(14)
           move "Mouse Input" to ws-display-text(15)
           move function concatenate(
           "  Interacting with this application can be done with either"
           " the keyboard or") to ws-display-text(16)
           move function concatenate(
           "  the mouse. When using the mouse, simply click on the feed"
           " item you would") to ws-display-text(17)
           move spaces to ws-display-text(18)                   
           
           exit paragraph.

       set-page-7-text.
           move function concatenate( 
           "  would like to open. You can also interact with the "
           "function key actions") to ws-display-text(1)
           move 
           "  by clicking on the text on the bottom bar." 
               to ws-display-text(2) 
           move spaces to ws-display-text(3) 
           move function concatenate(
           "  When using the configuration screen, you can click on "
           "the setting") to ws-display-text(4) 
           move function concatenate(
           "  you would like to set. The clicked setting will be saved "
           "automatically") to ws-display-text(5)
           move spaces to ws-display-text(6)  
           move "  upon selection." to ws-display-text(6) 
           move spaces to ws-display-text(7)  
           move "RSS Feed Colors" to ws-display-text(8)  
           move function concatenate(
           "  RSS feeds in the main RSS feed list will be displayed in "
           "white if") to ws-display-text(9)  
           move function concatenate(
           "  the last time the feed was downloaded and parsed was "
           "successful. If") to ws-display-text(10)  
           move function concatenate(
           "  there was any errors in the last download and parse "
           "attempt, the feed") to ws-display-text(11)  
           move function concatenate(
           "  will be displayed in red until the errors are cleared."
           "(Usually through")  to ws-display-text(12)  
           move 
           "  refreshing or trying different configuration settings.)"
               to ws-display-text(13)  
           move spaces to ws-display-text(14)  
           move spaces to ws-display-text(15) 
           move spaces to ws-display-text(16)  
           move spaces to ws-display-text(17)  
           move spaces to ws-display-text(18)   
           exit paragraph. 

       set-page-8-text.           

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
           move " -----------------------------------------------------" 
               to ws-display-text(13)
           move function concatenate(" cobweb-pipes library created by ", 
           "Brian Tiffin and Simon Sobisch.") to ws-display-text(14)
           move function concatenate(" URL: ",
           "https://sourceforge.net/p",
           "/gnucobol/contrib/HEAD/tree/") to ws-display-text(15)
           move "      trunk/tools/cobweb/cobweb-pipes/" 
               to ws-display-text(16)
           move spaces to ws-display-text(17)
           move spaces to ws-display-text(18)
           
           set ws-last-page to true 

           exit paragraph.
       end program rss-reader-help.
