      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-30
      * Last Modified: 2021-09-27
      * Purpose: Launches url in lynx web browser
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. browser-launcher.

       environment division.
       
       configuration section.

       repository.
           function get-config 
           function pipe-open
           function pipe-close.

       input-output section.

       data division.
       file section.

       working-storage section.

       01  ws-pipe-record.
           05  ws-pipe-pointer                  usage pointer.
           05  ws-pipe-return                   usage binary-long.

       01  ws-web-cmd.
           05  ws-web-cmd-start                 pic x(32) value spaces.
           05  ws-browser-cmd                   pic x(32) value "lynx ".
           05  ws-url                           pic x(255) value spaces. 
           05  ws-web-cmd-end                   pic x(10) value spaces.

       77  ws-launch-status                     pic 9 value 9.
      
       local-storage section.

       01  ls-config-val-temp                   pic x(32) value spaces.

       linkage section.

       01  l-item-link                          pic x any length.

       screen section.
       
       copy "./screens/blank_screen.cpy".


       procedure division using 
           l-item-link.

       main-procedure.

      * TODO : currently breaks user input. needs work.... tab shift+Tab still work. not arrow keys.
      *        invalid url causes the input to be all wonky. currenlty urls are wonky.
      * NOTE : This is only the case if browser is not opened in a new terminal window!     

           display spaces blank screen 

           move function get-config("browser") to ws-browser-cmd           

           if ws-browser-cmd = "NOT-SET" then 
               call "logger" using function concatenate(
                   "browser configuration is currently set to 'NOT-SET'"
                   ". Cannot launch item link: " l-item-link)
               end-call 
               goback 
           end-if 

           move function trim(l-item-link) to ws-url

           move function substitute(ws-url, "&", "\&") to ws-url          

           move function get-config("newwin") to ls-config-val-temp
           if ls-config-val-temp = "true" then 
               move function get-config("newwin_s") to ws-web-cmd-start
               move function get-config("newwin_e") to ws-web-cmd-end
           end-if 

           call "logger" using ws-url 

           call "logger" using function concatenate(
               "Launching item in browser using command: ",
               ws-web-cmd)
           end-call

           move pipe-open(ws-web-cmd, "w") to ws-pipe-record
           
           call "logger" using "pipe open called..."

           if ws-pipe-return not equal 255 then
               call "logger" using "pipe return value check."
               move pipe-close(ws-pipe-record) to ws-launch-status
               
               if ws-launch-status is zero then
                   call "logger" using function concatenate(
                       "Web launch success. Status=", ws-launch-status)
                   end-call 
               else
                   call "logger" using function concatenate(
                       "Error launching ", function trim(ws-web-cmd), 
                       ".. Status=", ws-launch-status)
                   end-call
               end-if
           end-if

           display spaces blank screen       

           goback.

       end program browser-launcher.
