      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-10-05
      * Last Modified: 2021-10-05
      * Purpose: Screen definition for rss_reader_configuration program.
      * Tectonics: ./build.sh
      ******************************************************************
       01  s-rss-config-screen           
           blank screen 
           foreground-color 7 
           background-color cob-color-black. 

           05  s-menu-screen-2. 

               10  s-title-line
                   foreground-color cob-color-white background-color 1. 
                   15  line 1 pic x(80) from ws-empty-line.
                   15  line 1 column 25 
                       value "COBOL RSS Reader Configuration". 

               10  s-header-line
                   foreground-color cob-color-black background-color 7.
                   15 line 2 pic x(80) from ws-empty-line.                                                       

               10  line 3 column 2 value 
           "Here you can manually set the configuration values for the".

               10  line 4 column 2 value 
           "application or choose to use the auto-configuration.".

               10  line 6 column 2 value 
           "Options that are currently enabled are in green.".

               10  line 8 column 2 value 
           "Place an 'x' next to the configs you want to set.".

               10  line 10 column 18 
                   value "RSS Download Command:".

               10  line 10 column 40 
                   pic x to ws-wget-enabled-config.

               10  line 10 column 42 
                   foreground-color ws-option-wget-fg-color
                   value "[wget]".
                
               10  line 11 column 40 
                   pic x to ws-curl-enabled-config.

               10  line 11 column 42
                   foreground-color ws-option-curl-fg-color
                   value "[curl]".

               10  line 13 column 27 
                   value "Web Browser:".
       
               10  line 13 column 40 
                   pic x to ws-lynx-enabled-config.

               10  line 13 column 42 
                   foreground-color ws-option-lynx-fg-color
                   value "[lynx]".

               10  line 14 column 40 
                   pic x to ws-links-enabled-config.

               10  line 14 column 42 
                   foreground-color ws-option-links-fg-color
                   value "[links]".

               10  line 15 column 40 
                   pic x to ws-no-browser-enabled-config.

               10  line 15 column 42 
                   foreground-color ws-option-no-browser-fg-color
                   value "[none]".

               10  line 17 column 8
                   value "Open items in new Xterm window?".

               10  line 17 column 40 
                   pic x to ws-xterm-enabled-config.

               10  line 17 column 42 
                   foreground-color ws-option-xterm-fg-color
                   value "[Yes]".

               10  line 17 column 48 
                   pic x to ws-xterm-disabled-config.

               10  line 17 column 50 
                   foreground-color ws-option-no-xterm-fg-color
                   value "[No]".

               10  line 19 column 7
                   value "Retry feed parsing with xmllint?".
                   
               10  line 19 column 40 
                   pic x to ws-xmllint-enabled-config.

               10  line 19 column 42 
                   foreground-color ws-option-xmllint-fg-color
                   value "[Yes]".

               10  line 19 column 48 
                   pic x to ws-xmllint-disabled-config.

               10  line 19 column 50 
                   foreground-color ws-option-no-xmllint-fg-color
                   value "[No]".


               10  s-help-text-1.
                   15  foreground-color cob-color-black  
                       background-color cob-color-white
                       line 21 column 3
                       value " F5 ".

                   15  foreground-color cob-color-white 
                       background-color cob-color-black 
                       line 21 column 8                       
                       value "Run Auto Configuration".

                   15  foreground-color cob-color-black
                       background-color cob-color-white 
                       line 21 column 31 
                       value " Enter ".

                   15  foreground-color cob-color-white
                       background-color cob-color-black
                       line 21 column 39
                       value "Save Changes".

                   15  foreground-color cob-color-black 
                       background-color cob-color-white 
                       line 21 column 52
                       value " ESC ".

                   15  foreground-color cob-color-white 
                       background-color cob-color-black 
                       line 21 column 58
                       value "Return to RSS List".
