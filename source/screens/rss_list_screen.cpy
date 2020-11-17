      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-11
      * Last Modified: 2020-11-17
      * Purpose: Screen definition for rss_reader_menu program.
      * Tectonics: ./build.sh
      ******************************************************************
       01  rss-list-screen           
           blank screen 
           foreground-color 7 
           background-color cob-color-black. 

           05 menu-screen-2. 

               10  title-line
                   foreground-color cob-color-white background-color 1. 

                   15 line 1 pic x(80) from empty-line.
                   15 line 1 column 32 value "COBOL RSS Reader". 

               10  header-line
                   foreground-color cob-color-black background-color 7.

                   15 line 2 pic x(80) from empty-line.                   
                   15 line 2 column 5 value "RSS Name".
                   15 line 2 column 40 value "RSS Feed URL".
               
               10  line 3  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(1).

               10  line 4  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(2).               

               10  line 5  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(3).        
     

               10  line 6  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(4).        


               10  line 7  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(5).        


               10  line 8  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(6).        


               10  line 9  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(7).        


               10  line 10  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(8).        


               10  line 11  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(9).        

               10  line 12  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(10).        

               10  line 13  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(11).        

               10  line 14  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(12).        

               10  line 15  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(13).        

               10  line 16  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(14).                            

               10  line 17  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(15).                            

               10  line 18  column 2 
                   pic x to accept-item1. 
               10  column 4 pic x(70) from ws-display-text(16).                            

               10  help-text 
                   foreground-color 2 background-color 0. 
                   
                   15  line 19 column 12 
                       value 
           " Use the arrow keys to move the cursor among RSS Feeds. ". 
                   
                   15  line 20 column 12 
                       value 
           " Press <Return> to view selected RSS Feed               ". 
          
                   15  line 21 column 12 
                       value 
           " Press <F10> to exit.                                   ".
