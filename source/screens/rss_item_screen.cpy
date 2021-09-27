      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-19
      * Last Modified: 2021-09-27
      * Purpose: Screen definition for rss_reader_view_item program.
      * Tectonics: ./build.sh
      ******************************************************************
       01  s-rss-item-screen           
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

               10  s-sub-header-line
                   foreground-color cob-color-black background-color 7.
                   15 line 3 pic x(80) from ws-empty-line.                   
                   15 line 3 column 2 pic x(70) from ws-feed-site-link. 
                                   
               10  line 4  column 2 
                   pic x to ws-accept-item. 

               10  s-item-title.
                   15 line 4 column 2 value "Item Title:".
                   15 line 4 column 14 pic x(65) from ws-item-title. 

               10  s-item-link.
                   15 line 5 column 2 value "Item Link:".
                   15 line 5 column 14 pic x(65) from ws-item-link.

               10  s-item-guid.
                   15 line 6 column 2 value "Item Guid:".
                   15 line 6 column 14 pic x(65) from ws-item-guid.

               10  s-item-pub-date.
                   15 line 7 column 2 value "Item Pub Date:". 
                   15 line 7 column 20 pic x(60) from ws-item-pub-date.

               10  s-item-description.
                   15 line 9 column 2 value "Item Description:".
                   15 line 10 column 2 value "-----------------".
                   15 line 11 column 2 
                      pic x(70) from ws-desc-line(1).

               10  s-item-description-2.
                   15 line 12 column 2 
                      pic x(70) from ws-desc-line(2).

               10  s-item-description-3.
                   15 line 13 column 2 
                      pic x(70) from ws-desc-line(3).

               10  s-item-description-4.
                   15 line 14 column 2 
                      pic x(70) from ws-desc-line(4).

               10  s-item-description-5.
                   15 line 15 column 2
                      pic x(70) from ws-desc-line(5).

               10  s-item-description-6.
                   15 line 16 column 2 
                      pic x(70) from ws-desc-line(6).

               10  s-item-description-7.
                   15 line 17 column 2 
                      pic x(70) from ws-desc-line(7).

               10  s-item-description-8.
                   15 line 18 column 2 
                      pic x(70) from ws-desc-line(8).

               10  s-help-text-1.
                   15  foreground-color ws-browser-key-fore-color 
                       background-color ws-browser-key-back-color 
                       line 21 column 3
                       pic x(7) from ws-browser-key-text.                   

                   15  foreground-color cob-color-white 
                       background-color cob-color-black 
                       line 21 column 11
                       pic x(25) from ws-browser-text.                   

                   15  foreground-color cob-color-black 
                       background-color cob-color-white 
                       line 21 column 35
                       value " ESC ".

                   15  foreground-color cob-color-white 
                       background-color cob-color-black 
                       line 21 column 41
                       value "Return to Item List".
