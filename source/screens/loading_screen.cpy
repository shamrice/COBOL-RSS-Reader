      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-21
      * Last Modified: 2020-12-27
      * Purpose: Screen definition for showing loading messaging.
      * Tectonics: ./build.sh
      ******************************************************************
       01  loading-screen           
           blank screen 
           foreground-color 7 
           background-color cob-color-black. 

           05 loading-screen-2. 

               10  title-line
                   foreground-color cob-color-white background-color 1. 
                   15  line 10 pic x(80) from empty-line.
                   15  line 10 column 25 
                       value "Loading...". 

               10  spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 11 pic x(80) from empty-line.                   
                   
               10  message-line
                   foreground-color cob-color-black background-color 7.
                   15  line 12 pic x(80) from empty-line.                   
                   15  line 12 column 4 pic x(70) from ws-loading-msg. 
 
               10  spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 13 pic x(80) from empty-line.                   
