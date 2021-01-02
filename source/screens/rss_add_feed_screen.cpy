      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-02
      * Last Modified: 2021-01-02
      * Purpose: Screen definition for adding feed.
      * Tectonics: ./build.sh
      ******************************************************************
       01  rss-add-feed-screen           
           blank screen 
           foreground-color 7 
           background-color cob-color-black. 

           05 rss-add-feed-screen-2. 

               10  title-line
                   foreground-color cob-color-white background-color 1. 
                   15  line 4 column 2 pic x(80) from empty-line.
                   15  line 4 column 35 value "Add RSS Feed". 

               10  spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 5 column 2 pic x(80) from empty-line.                 
                   
               10  message-line
                   foreground-color cob-color-black background-color 7.
                   15  line 6 column 2 pic x(80) from empty-line.
                   15  line 6 column 3 
                   value "Enter RSS Feed URL to Add or ESC to Cancel:".   

               10  spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 7 column 2 pic x(80) from empty-line.                 

               10  input-line
                   foreground-color cob-color-black background-color 7.
                   15  line 8 column 2 pic x(80) from empty-line.                   
                   15  line 8 column 3 pic x(78) to ws-rss-url. 
 
               10  spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 9 column 2 pic x(80) from empty-line.                   
