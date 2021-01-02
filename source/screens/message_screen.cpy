      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-21
      * Last Modified: 2021-01-02
      * Purpose: Screen definition for showing info messages.
      * Tectonics: ./build.sh
      ******************************************************************
       01  message-screen           
           blank screen 
           foreground-color 7 
           background-color cob-color-black. 

           05 message-screen-2. 

               10  title-line
                   foreground-color cob-color-white background-color 1. 
                   15  line 11 column 10 pic x(60) from empty-line.
                   15  line 11 column 12 pic x(50) from ws-msg-title. 

               10  spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 12 column 10 pic x(60) from empty-line.                   
                   
               10  message-line-1
                   foreground-color cob-color-black background-color 7.
                   15  line 13 column 10 pic x(60) from empty-line.                   
                   15  line 13 column 12 
                       pic x(50) from ws-msg-body-text(1). 
 
               10  message-line-2
                   foreground-color cob-color-black background-color 7.
                   15  line 14 column 10 pic x(60) from empty-line.                   
                   15  line 14 column 12 
                       pic x(50) from ws-msg-body-text(2). 

               10  spacer-line
                   foreground-color cob-color-black background-color 7.
                   15  line 15 column 10 pic x(60) from empty-line.    

               10  input-line
                   foreground-color 7 background-color 7.
                   15  line 15  column 10 pic x to ws-msg-input. 
