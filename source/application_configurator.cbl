      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2021-01-11
      *> Last Updated: 2021-01-11
      *> Purpose: Sub program to save or update configuration value.
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************

       identification division.
       program-id. save-config.

       environment division.

       configuration section.

       input-output section.
           file-control.
               select optional config-file
               assign to dynamic ws-file-name
               organization is indexed
               access is dynamic
               record key is config-name.           

       data division.

       file section.
           FD config-file.
           01  config-set.
               05  config-name             pic x(8).
               05  config-value            pic x(16).    

       working-storage section.

       77  ws-file-name                    pic x(18) value "crssr.conf".

       local-storage section.
       
       01  ws-config-set.
           05  ws-config-name              pic x(8) value spaces.
           05  ws-config-value             pic x(16) value spaces.

       01  ws-record-exists-sw             pic x value 'N'.
           88  ws-record-exists            value 'Y'.
           88  ws-record-not-exists        value 'N'. 

       linkage section.

       01  ls-config-name                  pic x any length.
       01  ls-config-value                 pic x any length.

       procedure division 
           using ls-config-name, ls-config-value.

       main-procedure.

           move ls-config-name to ws-config-name
           move ls-config-value to ws-config-value

           call "logger" using function concatenate(
               "Saving configuration: ", ws-config-name, 
               " with value: ", ws-config-value)
           end-call 

      * make sure file exists.           
           open extend config-file
           close config-file

           open i-o config-file
               write config-set from ws-config-set
                   invalid key 
                       call "logger" using 
                           "Config key already exists in list."
                       end-call 
                       set ws-record-exists to true 
                   not invalid key 
                       call "logger" using 
                           "Saved new Config to config file"
                       end-call 
                       set ws-record-not-exists to true 
               end-write

               if ws-record-exists then 
                   rewrite config-set from ws-config-set
                       invalid key
                           call "logger" using function concatenate(
                               "Config record exists but rewrite ",
                               "failed on invalid key for config set: ", 
                               ws-config-set)
                           end-call
                       not invalid key
                           call "logger" using function concatenate(
                               "Config record updated with new value: ",
                               ws-config-set)
                           end-call
                   end-rewrite
               end-if
           close config-file

           goback.
       
       end program save-config.


      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2021-01-11
      *> Last Updated: 2021-01-11
      *> Purpose: Function to get configuration value for config 
      *>          name passed.
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************

       identification division.
       function-id. get-config.

       environment division.

       configuration section.

       input-output section.
           file-control.
               select optional config-file
               assign to dynamic ws-file-name
               organization is indexed
               access is dynamic
               record key is config-name.           

       data division.

       file section.
           FD  config-file.
           01  config-set.
               05  config-name           pic x(8).
               05  config-value          pic x(16).    

       working-storage section.

       77  ws-file-name               pic x(18) value "crssr.conf".

       local-storage section.
       
       01  ws-config-set.
           05  ws-config-name              pic x(8) value spaces.
           05  ws-config-value             pic x(16) value spaces.

       linkage section.

       01  ls-config-name                   pic x any length.
       01  ls-config-value                  pic x(16).

       procedure division 
           using ls-config-name
           returning ls-config-value.

       main-procedure.

           call "logger" using function concatenate(
               "Getting value for configuration: ", ls-config-name)
           end-call 
       
           move ls-config-name to ws-config-name
           move spaces to ls-config-value 
           
      * make sure file exists.           
           open extend config-file
           close config-file

           open input config-file
               move ws-config-name to config-name
               read config-file into ws-config-set
                   key is config-name
                   invalid key 
                       call "logger" using function concatenate(
                          "Unable to find config with name: ", 
                          config-name, " : Returning spaces.")
                       end-call 
                   not invalid key          
                       call "logger" using function concatenate(
                           "Config found :: name: ", ws-config-name, 
                           " : value: ", ws-config-value)
                       end-call                          
                       move ws-config-value to ls-config-value 
               end-read     
           close config-file      

           goback.
       
       end function get-config.

