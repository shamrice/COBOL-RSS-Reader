      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2020-12-26
      *> Last Updated: 2020-01-11
      *> Purpose: File logger for CRSSR
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************

       replace ==:BUFFER-SIZE:== by ==32768==.

       identification division.
       program-id. logger.

       environment division.

       configuration section.

       input-output section.
           file-control.
               select optional log-file
               assign to dynamic ws-file-name
               organization is line sequential.

       data division.

       file section.
           FD log-file.
           01 log-text-raw                 pic x(:BUFFER-SIZE:).


       working-storage section.

       01  ws-date-record.
           05  ws-current-date.
               10  ws-year               pic 9(4).
               10  ws-month              pic 99.
               10  ws-day                pic 99.
           05 ws-current-time.
               10  ws-hour               pic 99.
               10  ws-min                pic 99.
               10  ws-sec                pic 99.
               10  ws-milli              pic 99.
           05  ws-time-offset            pic S9(4).

       01  log-enabled-sw                pic a value 'N'.
           88  log-enabled               value 'Y'.
           88  log-disabled              value 'N'.

       77  ws-log-buffer                 pic x(:BUFFER-SIZE:).

       77  ws-file-name               pic x(18) value "crssr_UNSET.log".

       78  log-enabled-switch            value "==ENABLE-LOG==".
       78  log-disabled-switch           value "==DISABLE-LOG==".


       linkage section.
       01  ls-log-text                   pic x any length.

       procedure division 
           using ls-log-text.

       main-procedure.

      * If log text is disable log flag or enable log flag, turn log enabled
      * switch on and off as needed.
           if ls-log-text = log-disabled-switch then
               set log-disabled to true
           end-if 

           if ls-log-text = log-enabled-switch then 
               set log-enabled to true
           end-if

           if log-disabled then 
               goback
           end-if 

           move spaces to ws-log-buffer

           move function current-date to ws-date-record
           
      * Dynamically create log file name using date in file name.
           string
               "crssr" delimited by size
               "_" delimited by size  
               ws-year delimited by size
               ws-month delimited by size
               ws-day delimited by size 
               ".log" delimited by size 
               into ws-file-name
           end-string

      * Build formatted log line for output.         
           string 
               "[" delimited by size
               ws-year delimited by size 
               "-" delimited by size 
               ws-month delimited by size
               "-" delimited by size 
               ws-day delimited by size 
               " " delimited by size
               ws-hour delimited by size
               ":" delimited by size
               ws-min delimited by size
               ":" delimited by size
               ws-sec delimited by size
               "." delimited by size
               ws-milli delimited by size
               "] " delimited by size
               ls-log-text delimited by size
               into ws-log-buffer
           end-string

           open extend log-file
               write log-text-raw from ws-log-buffer
           close log-file

           goback.
       
       end program logger.
