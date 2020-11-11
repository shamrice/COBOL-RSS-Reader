      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-11
      * Last Modified: 2020-11-11
      * Purpose: Screen definition for rss_reader_menu program.
      * Tectonics: ./build.sh
      ******************************************************************
       01 header-screen.
           05 filler line 2 column 13
               value "Current List of RSS Feeds:"      
               blank screen
               foreground-color cob-color-white
               background-color cob-color-black.
      
       01 main-function-screen.
           05 filler line 25 column 1
               value "F1 - View Selected RSS Feed"
               foreground-color cob-color-white.             
             
           05 filler line 25 column 30
               value "F2 - Select Next"
               foreground-color cob-color-white.
      
           05 filler line 25 column 47
               value "F3 - Select Previous"
               foreground-color cob-color-white.             

           05 filler line 25 column 70
               value "F9 - Exit Program"
               foreground-color cob-color-white.             

           05 filler pic x to ws-accept-func-key secure
               line 18 column 79
               foreground-color cob-color-white.             
