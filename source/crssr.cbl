      *>*****************************************************************
      *> Author: Erik Eriksen
      *> Create Date: 2020-11-05
      *> Last Updated: 2020-12-27
      *> Purpose: Application entry point
      *> Tectonics:
      *>     ./build.sh
      *>*****************************************************************

       identification division.
       program-id. cobol-rss-reader.

       environment division.

       configuration section.

       repository.
           function logger.

       data division.

       working-storage section.

       77 command-arguments                    pic x(2048) value spaces.

       77 is-valid-param                       pic a value 'N'.

       78 new-line                             value x"0a".

       78 program-version                      value __APP_VERSION.
       78 web-url  value __SOURCE_URL.
       78 build-date                           value __BUILD_DATE.


       procedure division.

       main-procedure.

           display
               new-line "COBOL RSS Reader v" program-version new-line
               "-----------------------------------------------" 
               new-line "By: Erik Eriksen"
               new-line "Web: " web-url
               new-line "Build Date: " build-date new-line 
           end-display

           accept command-arguments from command-line end-accept
          
      *> No where near perfect... but will at least check if user has some url in their input.
           if command-arguments(1:4) = "http" or "HTTP" then
               move 'Y' to is-valid-param
               call "rss-downloader" using by content command-arguments        
           end-if

           if command-arguments = spaces then
               move 'Y' to is-valid-param
               call "rss-reader-menu"
           end-if

           if is-valid-param = 'N' then
               perform print-help
           end-if
     
           stop run.

       print-help.

           display
               "CRSSR is a console RSS reader application written in "
               "COBOL." new-line new-line
               "Add new feed:" new-line
               "  Usage: crssr [url of rss feed]" new-line new-line
               "Run application with no arguments to start application "
               "in interactive mode." new-line
           end-display.

       end program cobol-rss-reader.
