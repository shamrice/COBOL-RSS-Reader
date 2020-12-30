      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-12-30
      * Last Modified: 2020-12-30
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
           05  browser-cmd                   pic x(10) value "lynx ".
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

      * TODO : currently breaks user input. needs work.

           display blank-screen 

           move ls-item-link to url

           call "logger" using function concatenate(
               "Launching item in browser using command: ",
               ws-web-cmd)
           end-call

           move pipe-open(ws-web-cmd, "w") to pipe-record
                  
           if pipe-return not equal 255 then
               move pipe-close(pipe-record) to launch-status
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

           goback.

       end program browser-launcher.
