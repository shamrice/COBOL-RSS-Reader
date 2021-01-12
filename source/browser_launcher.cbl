      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-30
      * Last Modified: 2021-01-12
      * Purpose: Launches url in lynx web browser
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. browser-launcher.

       environment division.
       
       configuration section.

       repository.
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
           05  ws-browser-cmd                   pic x(5) value "lynx ".
           05  ws-url                           pic x(255) value spaces.
  
       77  empty-line                        pic x(80) value spaces. 

       77  ws-launch-status                     pic 9 value 9.
      
       linkage section.

       01  l-item-link                          pic x any length.

       screen section.
       
       copy "./screens/blank_screen.cpy".


       procedure division using 
           l-item-link.

       main-procedure.

      * TODO : currently breaks user input. needs work.... tab shift+Tab still work. not arrow keys.
      *        invalid url causes the input to be all wonky. currenlty urls are wonky.

           display s-blank-screen 

           move function trim(l-item-link) to ws-url

           move function substitute(ws-url, "&", "\&") to ws-url

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

           accept s-blank-screen 

           goback.

       end program browser-launcher.
