      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-03
      * Last Modified: 2021-01-12
      * Purpose: Screen definition for deleting feed.
      * Tectonics: ./build.sh
      ******************************************************************
       01  s-rss-delete-feed-screen           
           blank screen 
           foreground-color 7 
           background-color cob-color-black. 

           05 s-rss-delete-feed-screen-2. 

               10  s-title-line
                   foreground-color cob-color-white background-color 1. 
                   15  line 4 column 1 pic x(80) from ws-empty-line.
                   15  line 4 column 35 value "Delete RSS Feed". 

               10  s-spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 5 column 1 pic x(80) from ws-empty-line.                 

               10  s-rss-name-line-1
                   foreground-color cob-color-black background-color 7.
                   15  line 6 column 1 pic x(80) from ws-empty-line.
                   15  line 6 column 2 pic x(70) from ws-delete-line-1.   


               10  s-rss-name-line-2
                   foreground-color cob-color-black background-color 7.
                   15  line 7 column 1 pic x(80) from ws-empty-line.
                   15  line 7 column 2 pic x(70) from ws-delete-line-2.   


               10  s-message-line
                   foreground-color cob-color-black background-color 7.
                   15  line 8 column 1 pic x(80) from ws-empty-line.
                   15  line 8 column 2 
               value "Press Enter to Delete RSS Feed or ESC to Cancel.".   

               10  s-input-line
                   foreground-color cob-color-black background-color 7.
                   15  line 9 column 1 pic x(80) from ws-empty-line.                   
                   15  line 9 column 2 pic x to ws-accept. 
 
               10  s-spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 10 column 1 pic x(80) from ws-empty-line.                   
