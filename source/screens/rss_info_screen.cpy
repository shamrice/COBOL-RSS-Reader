      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-16
      * Last Modified: 2021-09-21
      * Purpose: Screen definition for rss_reader_view_feed program.
      * Tectonics: ./build.sh
      ******************************************************************
       01  s-rss-info-screen           
           blank screen 
           foreground-color 7 
           background-color cob-color-black. 

           05  s-menu-screen-2. 

               10  s-title-line
                   foreground-color cob-color-white background-color 1. 
                   15  line 1 pic x(80) from ws-empty-line.
                   15  line 1 column 25 
                       value "COBOL RSS Reader - View Feed". 

               10  s-header-line
                   foreground-color cob-color-black background-color 7.
                   15 line 2 pic x(80) from ws-empty-line.                   
                   15 line 2 column 2 pic x(70) from ws-feed-title.

               10  s-sub-header-line-1
                   foreground-color cob-color-black background-color 7.
                   15 line 3 pic x(80) from ws-empty-line.                   
                   15 line 3 column 2 pic x(70) from ws-feed-site-link. 
                                   
               10  s-sub-header-line-2
                   foreground-color cob-color-black background-color 7.
                   15 line 4 pic x(80) from ws-empty-line.                   
                   15 line 4 column 2 pic x(70) from ws-feed-desc. 
                                   
               10  line 5  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(1).        


               10  line 6  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(2).        


               10  line 7  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(3).        


               10  line 8  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(4).        


               10  line 9  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(5).        

               10  line 10  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(6).        

               10  line 11  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(7).        

               10  line 12  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(8).        

               10  line 13  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(9).        

               10  line 14  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(10).                            

               10  line 15  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(11).                            

               10  line 16  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(12).                            

               10  line 17  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(13). 

               10  line 18  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(14). 

               10  line 19  column 2 
                   pic x to ws-accept-item. 
               10  column 4 pic x(70) from ls-display-item-title(15). 

               10  s-help-text-1.
                   15  foreground-color cob-color-black 
                   background-color cob-color-white line 21 column 8
                   value " Enter ".

                   15  foreground-color cob-color-white 
                   background-color cob-color-black line 21 column 16
                   value "View Feed Item".

                   15  foreground-color cob-color-black 
                   background-color cob-color-white line 21 column 35
                   value " ESC ".

                   15  foreground-color cob-color-white 
                   background-color cob-color-black line 21 column 41
                   value "Return to RSS List".

