      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-16
      * Last Modified: 2021-01-09
      * Purpose: Screen definition for rss_reader_view_feed program.
      * Tectonics: ./build.sh
      ******************************************************************
       01  rss-info-screen           
           blank screen 
           foreground-color 7 
           background-color cob-color-black. 

           05 menu-screen-2. 

               10  title-line
                   foreground-color cob-color-white background-color 1. 
                   15  line 1 pic x(80) from empty-line.
                   15  line 1 column 25 
                       value "COBOL RSS Reader - View Feed". 

               10  header-line
                   foreground-color cob-color-black background-color 7.
                   15 line 2 pic x(80) from empty-line.                   
                   15 line 2 column 2 pic x(70) from ws-feed-title.

               10 sub-header-line-1
                   foreground-color cob-color-black background-color 7.
                   15 line 3 pic x(80) from empty-line.                   
                   15 line 3 column 2 pic x(70) from ws-feed-site-link. 
                                   
               10  sub-header-line-2
                   foreground-color cob-color-black background-color 7.
                   15 line 4 pic x(80) from empty-line.                   
                   15 line 4 column 2 pic x(70) from ws-feed-desc. 
                                   
               10  line 5  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(1).        


               10  line 6  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(2).        


               10  line 7  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(3).        


               10  line 8  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(4).        


               10  line 9  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(5).        

               10  line 10  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(6).        

               10  line 11  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(7).        

               10  line 12  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(8).        

               10  line 13  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(9).        

               10  line 14  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(10).                            

               10  line 15  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(11).                            

               10  line 16  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(12).                            

               10  line 17  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(13). 

               10  line 18  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(14). 

               10  line 19  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ws-item-title(15). 

               10  help-text 
                   foreground-color 2 background-color 0. 
                   
                   15  line 20 column 12 
                       value 
           " Use the arrow keys to move the cursor among RSS Entries. ". 
                   
                   15  line 21 column 12 
                       value 
           " Press <Return> to view selected RSS Feed Entry           ". 
          
                   15  line 22 column 12 
                       value 
           " Press <ESC> to return to previous menu.                  ".
