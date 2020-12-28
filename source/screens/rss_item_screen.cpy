      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-19
      * Last Modified: 2020-12-28
      * Purpose: Screen definition for rss_reader_view_item program.
      * Tectonics: ./build.sh
      ******************************************************************
       01  rss-item-screen           
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
                   15 line 2 column 2 pic x(70) from ls-feed-title.

               10  sub-header-line
                   foreground-color cob-color-black background-color 7.
                   15 line 3 pic x(80) from empty-line.                   
                   15 line 3 column 2 pic x(70) from ls-feed-site-link. 
                                   
               10  line 4  column 2 
                   pic x to ws-accept-item. 

               10  item-title.
                   15 line 4 column 2 value "Item Title:".
                   15 line 4 column 14 pic x(65) from ls-item-title. 

               10  item-link.
                   15 line 5 column 2 value "Item Link:".
                   15 line 5 column 14 pic x(65) from ls-item-link.

               10  item-guid.
                   15 line 6 column 2 value "Item Guid:".
                   15 line 6 column 14 pic x(65) from ls-item-guid.

               10  item-pub-date.
                   15 line 7 column 2 value "Item Pub Date:". 
                   15 line 7 column 20 pic x(60) from ls-item-pub-date.

               10  item-description.
                   15 line 9 column 2 value "Item Description:".
                   15 line 10 column 2 value "-----------------".
                   15 line 11 column 2 
                      pic x(70) from ls-item-desc(1:70).

               10  item-description-2.
                   15 line 12 column 2 
                      pic x(70) from ls-item-desc(71:140).

               10  item-description-3.
                   15 line 13 column 2 
                      pic x(70) from ls-item-desc(141:210).

               10  item-description-4.
                   15 line 14 column 2 
                      pic x(70) from ls-item-desc(211:280).

      *         10  item-description-5.
      *             15 line 15 column 2
      *                pic x(70) from ls-item-desc(281:350).

      *         10  item-description-6.
      *             15 line 16 column 2 
      *                pic x(70) from ls-item-desc(351:420).

      *         10  item-description-7.
      *             15 line 17 column 2 
      *                pic x(70) from ls-item-desc(421:490).

      *         10  item-description-8.
      *             15 line 18 column 2 
      *                pic x(70) from ls-item-desc(491:512).

               10  help-text 
                   foreground-color 2 background-color 0. 
                   
                   15  line 19 column 12 
                       value 
           " Use the arrow keys to move the cursor among RSS Entries. ". 
                   
                   15  line 20 column 12 
                       value 
           " Press <Return> to view selected RSS Feed Entry           ". 
          
                   15  line 21 column 12 
                       value 
           " Press <F10> to exit.                                   ".
