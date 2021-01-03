      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-03
      * Last Modified: 2021-01-03
      * Purpose: Screen definition for deleting feed.
      * Tectonics: ./build.sh
      ******************************************************************
       01  rss-delete-feed-screen           
           blank screen 
           foreground-color 7 
           background-color cob-color-black. 

           05 rss-add-feed-screen-2. 

               10  title-line
                   foreground-color cob-color-white background-color 1. 
                   15  line 4 column 2 pic x(80) from empty-line.
                   15  line 4 column 35 value "Delete RSS Feed". 

               10  spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 5 column 2 pic x(80) from empty-line.                 

               10  rss-name-line-1
                   foreground-color cob-color-black background-color 7.
                   15  line 6 column 2 pic x(80) from empty-line.
                   15  line 6 column 3 pic x(70) from ws-delete-line-1.   


               10  rss-name-line-2
                   foreground-color cob-color-black background-color 7.
                   15  line 7 column 2 pic x(80) from empty-line.
                   15  line 7 column 3 pic x(70) from ws-delete-line-2.   


               10  message-line
                   foreground-color cob-color-black background-color 7.
                   15  line 8 column 2 pic x(80) from empty-line.
                   15  line 8 column 3 
               value "Press Enter to Delete RSS Feed or ESC to Cancel.".   

               10  input-line
                   foreground-color cob-color-black background-color 7.
                   15  line 9 column 2 pic x(80) from empty-line.                   
                   15  line 9 column 3 pic x to ws-accept. 
 
               10  spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 10 column 2 pic x(80) from empty-line.                   
