      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-07
      * Last Modified: 2020-11-07
      * Purpose: RSS Reader for parsed feeds.
      * Tectonics: ./build.sh
      *    cobc -x crssr.cbl rss_parser.cbl rss_reader.cbl cobweb-pipes.cob -o crssr
      ******************************************************************
       identification division.
       program-id. rss-reader.

       data division.
       file section.

       working-storage section.

       procedure division.
       main-procedure.
            display "In RSS reader."
            goback.

       exit program.
