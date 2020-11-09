      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-07
      * Last Modified: 2020-11-09
      * Purpose: RSS Reader for parsed feeds.
      * Tectonics: ./build.sh
      *    cobc -x crssr.cbl rss_parser.cbl rss_reader.cbl cobweb-pipes.cob -o crssr
      ******************************************************************
       identification division.
       program-id. rss-reader.

       environment division.
       
       configuration section.

       input-output section.
           file-control.
               select rss-input-file
               assign to dynamic ws-rss-input-file-name
               organization is line sequential.


       data division.
       file section.
           FD rss-input-file.
           01 rss-input-record.
               05 feed-title                    pic x(255) value spaces.
               05 feed-link                     pic x(255) value spaces.
               05 feed-desc                     pic x(255) value spaces.
               05 items                         occurs 30 times.
                   10 item-exists               pic a value 'N'.
                   10 item-title                pic x(255) value spaces.
                   10 item-link                 pic x(255) value spaces.
                   10 item-guid                 pic x(255) value spaces.
                   10 item-pub-date             pic x(255) value spaces.
                   10 item-desc                 pic x(511) value spaces.

       working-storage section.

       01 ws-rss-record.
           05 ws-feed-title                    pic x(255) value spaces.
           05 ws-feed-link                     pic x(255) value spaces.
           05 ws-feed-desc                     pic x(255) value spaces.
           05 ws-items                         occurs 30 times.
               10 ws-item-exists               pic a value 'N'.
               10 ws-item-title                pic x(255) value spaces.
               10 ws-item-link                 pic x(255) value spaces.
               10 ws-item-guid                 pic x(255) value spaces.
               10 ws-item-pub-date             pic x(255) value spaces.
               10 ws-item-desc                 pic x(511) value spaces.

       01 eof-sw                                   pic a value 'N'.
           88 eof                                   value 'Y'.
           88 not-eof                               value 'N'.
       
      *> Temp placeholder. Will dynamically pull based on list file.
       78 ws-rss-input-file-name    value "./feeds/rss_00001.dat".



       procedure division.
       main-procedure.
            display "In RSS reader."

           open input rss-input-file
               perform until eof
                   read rss-input-file into ws-rss-record
                       at end move 'Y' to eof-sw
                   not at end
                       display function trim(ws-feed-title)
                       display function trim(item-title(1))
                   end-read
               end-perform
           close rss-input-file.

            goback.

       exit program.
