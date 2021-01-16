      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-15
      * Last Modified: 2021-01-15
      * Purpose: Screen definition for exporting feed.
      * Tectonics: ./build.sh
      ******************************************************************
       01  s-rss-export-feed-screen           
           blank screen 
           foreground-color 7 
           background-color cob-color-black. 

           05 s-rss-export-feed-screen-2. 

               10  s-title-line
                   foreground-color cob-color-white background-color 1. 
                   15  line 4 column 1 pic x(80) from ws-empty-line.
                   15  line 4 column 35 value "Export RSS Feed". 

               10  s-spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 5 column 1 pic x(80) from ws-empty-line.                 

               10  s-rss-export-msg-line-1
                   foreground-color cob-color-black background-color 7.
                   15  line 6 column 1 pic x(80) from ws-empty-line.
                   15  line 6 column 2 pic x(70) from ws-export-line-1.   


               10  s-rss-export-msg-line-2
                   foreground-color cob-color-black background-color 7.
                   15  line 7 column 1 pic x(80) from ws-empty-line.
                   15  line 7 column 2 pic x(70) from ws-export-line-2.   

               10  s-spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 8 column 1 pic x(80) from ws-empty-line.                   

               10  s-input-line
                   foreground-color cob-color-black background-color 7.
                   15  line 9 column 1 pic x(80) from ws-empty-line.                   
                   15  line 9 column 2 pic x(78) to ws-export-name. 
 
                10  s-spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 10 column 1 pic x(80) from ws-empty-line.                   

               10  s-message-line
                   foreground-color cob-color-black background-color 7.
                   15  line 11 column 1 pic x(80) from ws-empty-line.
                   15  line 11 column 2 
               value "Press Enter to Export RSS Feed or ESC to Cancel.".   
 
               10  s-spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 12 column 1 pic x(80) from ws-empty-line.                   
