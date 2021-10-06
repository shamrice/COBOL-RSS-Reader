      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-11
      * Last Modified: 2021-10-05
      * Purpose: Screen definition for rss_reader_menu program.
      * Tectonics: ./build.sh
      ******************************************************************
       01  s-rss-list-screen           
           blank screen 
           foreground-color 7 
           background-color cob-color-black. 

           05  s-menu-screen-2. 

               10  s-title-line
                   foreground-color cob-color-white background-color 1. 

                   15 line 1 pic x(80) from ws-empty-line.
                   15 line 1 column 32 value "COBOL RSS Reader". 

               10  s-header-line
                   foreground-color cob-color-black background-color 7.

                   15 line 2 pic x(80) from ws-empty-line.                   
                   15 line 2 column 5 value "RSS Feed Name".
               
               10  line 3  column 2 pic x to accept-item1. 

      *> For some reason, ws-display-text-color needs to be called twice
      *> the first time (regardless of index). On the first call, it 
      *> always returns nothing. On the second time, it gets the correct
      *> value. Not sure if this is a GnuCOBOL bug or not.
               10  column 4                          
                   foreground-color ws-display-text-color(1)       
                   pic x(70) from ws-display-list-title(1).

               10  column 4 
                   foreground-color ws-display-text-color(1)
                   pic x(70) from ws-display-list-title(1).

               10  line 4  column 2 pic x to accept-item1. 
               10  column 4 
                   foreground-color ws-display-text-color(2)                   
                   pic x(70) from ws-display-list-title(2).               

               10  line 5  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(3)
                   pic x(70) from ws-display-list-title(3).        
     

               10  line 6  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(4)
                   pic x(70) from ws-display-list-title(4).        


               10  line 7  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(5)
                   pic x(70) from ws-display-list-title(5).        


               10  line 8  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(6)
                   pic x(70) from ws-display-list-title(6).        


               10  line 9  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(7)
                   pic x(70) from ws-display-list-title(7).        


               10  line 10  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(8)
                   pic x(70) from ws-display-list-title(8).        


               10  line 11  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(9)
                   pic x(70) from ws-display-list-title(9).        

               10  line 12  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(10)
                   pic x(70) from ws-display-list-title(10).        

               10  line 13  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(11)
                   pic x(70) from ws-display-list-title(11).        

               10  line 14  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(12)
                   pic x(70) from ws-display-list-title(12).        

               10  line 15  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(13)
                   pic x(70) from ws-display-list-title(13).        

               10  line 16  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(14)
                   pic x(70) from ws-display-list-title(14).                            

               10  line 17  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(15)
                   pic x(70) from ws-display-list-title(15).                            

               10  line 18  column 2 pic x to accept-item1. 
               10  column 4 foreground-color ws-display-text-color(16)
                   pic x(70) from ws-display-list-title(16).                            

               10  s-help-line-1
                   foreground-color cob-color-black background-color 7.

                   15  line 20 pic x(80) from ws-empty-line.                   
                   15  line 20 column 8
                       value 
            "Arrow Keys or Tab to move between feeds. Enter to select.".

               10  s-help-text-2.
                   15  foreground-color cob-color-black 
                   background-color cob-color-white line 21 column 2
                   value "F1".

                   15  foreground-color cob-color-white 
                   background-color cob-color-black line 21 column 5
                   value "Help".

                   15  foreground-color cob-color-black 
                   background-color cob-color-white line 21 column 10
                   value "F3".

                   15  foreground-color cob-color-white 
                   background-color cob-color-black line 21 column 13
                   value "Add Feed".

                   15  foreground-color cob-color-black 
                   background-color cob-color-white line 21 column 22
                   value "F4".

                   15  foreground-color cob-color-white 
                   background-color cob-color-black line 21 column 25
                   value "Delete Feed".

                   15  foreground-color cob-color-black 
                   background-color cob-color-white line 21 column 37
                   value "F5".

                   15  foreground-color cob-color-white 
                   background-color cob-color-black line 21 column 40
                   value "Refresh".

                   15  foreground-color cob-color-black 
                   background-color cob-color-white line 21 column 48
                   value "F8".

                   15  foreground-color cob-color-white 
                   background-color cob-color-black line 21 column 51
                   value "Export".

                   15  foreground-color cob-color-black
                   background-color cob-color-white line 21 column 58
                   value "F9".

                   15  foreground-color cob-color-white
                   background-color cob-color-black line 21 column 61
                   value "Config".

                   15  foreground-color cob-color-black
                   background-color cob-color-white line 21 column 68
                   value "F10".

                   15  foreground-color cob-color-white 
                   background-color cob-color-black line 21 column 72
                   value "Exit".
