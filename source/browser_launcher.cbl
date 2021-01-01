      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-30
      * Last Modified: 2021-01-01
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

       01  crt-status. 
           05  key1                          pic x. 
           05  key2                          pic x. 
           05  filler                        pic x. 
           05  filler                        pic x.

       01  pipe-record.
           05  pipe-pointer                  usage pointer.
           05  pipe-return                   usage binary-long.

       01  ws-web-cmd.
           05  browser-cmd                   pic x(5) value "lynx ".
           05  url                           pic x(255) value spaces.
  
       77  empty-line                        pic x(80) value spaces. 

       77  launch-status                     pic 9 value 9.
      
       linkage section.

       01  ls-item-link                      pic x any length.

       screen section.
       
       copy "./screens/blank_screen.cpy".


       procedure division using 
           ls-item-link.

       main-procedure.

      * TODO : currently breaks user input. needs work.... tab shift+Tab still work. not arrow keys.
      *        invalid url causes the input to be all wonky. currenlty urls are wonky.

           display blank-screen 

           move function trim(ls-item-link) to url

           move function substitute(url, "&", "\&") to url

           call "logger" using function concatenate(
               "Launching item in browser using command: ",
               ws-web-cmd)
           end-call

           move pipe-open(ws-web-cmd, "w") to pipe-record
           
           call "logger" using "pipe open called..."

           if pipe-return not equal 255 then
               call "logger" using "pipe return value check."
               move pipe-close(pipe-record) to launch-status
               call "logger" using "pipe close return = " launch-status
               if launch-status is zero then
                   call "logger" using function concatenate(
                       "Web launch success. Status=", launch-status)
                   end-call 
               else
                   call "logger" using function concatenate(
                       "Error launching ", function trim(ws-web-cmd), 
                       ".. Status=", launch-status)
                   end-call
               end-if
           end-if

           accept blank-screen 

           goback.

       end program browser-launcher.
