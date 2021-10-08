      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-10
      * Last Modified: 2021-10-08
      * Purpose: Screen definition for help.
      * Tectonics: ./build.sh
      ******************************************************************
       01  s-rss-help-screen           
           blank screen 
           foreground-color cob-color-white 
           background-color cob-color-black. 

           05 s-rss-help-screen-2. 

               10  s-title-line
                   foreground-color cob-color-white 
                   background-color cob-color-blue. 
                   15  line 1 column 1 pic x(80) from ws-empty-line.
                   15  line 1 column 28 value "COBOL RSS Reader Help". 

               10  s-spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 2 column 1 pic x(80) from ws-empty-line.                 
                   
               10  s-message-lines
                   foreground-color cob-color-white 
                   background-color cob-color-black.
                   15  line 3 column 1 pic x(78) from ws-help-text(1).
                   15  line 4 column 1 pic x(78) from ws-help-text(2).
                   15  line 5 column 1 pic x(78) from ws-help-text(3).
                   15  line 6 column 1 pic x(78) from ws-help-text(4).
                   15  line 7 column 1 pic x(78) from ws-help-text(5).
                   15  line 8 column 1 pic x(78) from ws-help-text(6).
                   15  line 9 column 1 pic x(78) from ws-help-text(7).
                   15  line 10 column 1 pic x(78) from ws-help-text(8).
                   15  line 11 column 1 pic x(78) from ws-help-text(9).
                   15  line 12 column 1 pic x(78) from ws-help-text(10).
                   15  line 13 column 1 pic x(78) from ws-help-text(11).
                   15  line 14 column 1 pic x(78) from ws-help-text(12).
                   15  line 15 column 1 pic x(78) from ws-help-text(13).
                   15  line 16 column 1 pic x(78) from ws-help-text(14).
                   15  line 17 column 1 pic x(78) from ws-help-text(15).
                   15  line 18 column 1 pic x(78) from ws-help-text(16).
                   15  line 19 column 1 pic x(78) from ws-help-text(17).
                   15  line 20 column 1 pic x(78) from ws-help-text(18).
                   
               10  s-input-line
                   foreground-color cob-color-black 
                   background-color cob-color-white.
                   15  line 2 column 1 pic x(80) from ws-empty-line.                   
                   15  line 2 column 2 pic x to ws-accept. 
 
               10  s-help-text-1.

                   15  foreground-color ws-prev-page-cmd-fg-color
                   background-color ws-prev-page-cmd-bg-color
                   line 21 column 4
                   value " PgUp ".

                   15  foreground-color ws-prev-page-text-fg-color
                   background-color ws-prev-page-text-bg-color
                   line 21 column 11
                   value "Previous Page".
                    

                   15  foreground-color ws-next-page-cmd-fg-color 
                   background-color ws-next-page-cmd-bg-color 
                   line 21 column 26
                   value " PgDn/Enter ".

                   15  foreground-color ws-next-page-text-fg-color 
                   background-color ws-next-page-text-bg-color 
                   line 21 column 39
                   value "Next Page".

                   15  foreground-color cob-color-black 
                   background-color cob-color-white line 21 column 50
                   value " ESC ".

                   15  foreground-color cob-color-white 
                   background-color cob-color-black line 21 column 56
                   value "Return to RSS List".
                   