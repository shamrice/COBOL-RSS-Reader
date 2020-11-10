      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-07
      * Last Modified: 2020-11-10
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

               select optional rss-list-file
               assign to dynamic ws-rss-list-file-name
               organization is indexed
               access is dynamic
               record key is rss-link
               alternate record key is rss-feed-id.

               select optional rss-last-id-file
               assign to dynamic ws-rss-last-id-file-name
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

           FD rss-list-file.
           01 rss-list-record.               
               05 rss-feed-id                  pic 9(5) value zeros.
               05 rss-dat-file-name            pic x(255) value spaces.
               05 rss-link                     pic x(255) value spaces.

           FD rss-last-id-file.
           01 rss-last-id-record               pic 9(5) value zeros.

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

       01 ws-rss-list-record.           
           05 ws-rss-feed-id                  pic 9(5) value zeros.
           05 ws-rss-dat-file-name            pic x(255) value spaces.
           05 ws-rss-link                     pic x(255) value spaces.

       01 eof-sw                                   pic a value 'N'.
           88 eof                                   value 'Y'.
           88 not-eof                               value 'N'.
       
       01 ws-last-id-record                   pic 9(5) value zeros.   

       77 counter                             pic 9(5) value zeros.

       78 new-line                                 value x"0a".

      *> Temp placeholder. Will dynamically pull based on list file.
       78 ws-rss-input-file-name    value "./feeds/rss_00001.dat".
       78 ws-rss-list-file-name     value "./feeds/list.dat".
       78 ws-rss-last-id-file-name           value "./feeds/lastid.dat".



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
           close rss-input-file

           display "End debug" new-line new-line

           perform load-highest-rss-record

           perform display-current-feeds

           goback.



       load-highest-rss-record.
                      
           move 'N' to eof-sw

           open input rss-last-id-file
               perform until eof
                   read rss-last-id-file into ws-last-id-record
                       at end move 'Y' to eof-sw                   
                   end-read
               end-perform
           close rss-last-id-file

           exit paragraph.


       display-current-feeds.

           display "Current Feeds: "

           open input rss-list-file
               
               perform until counter > ws-last-id-record   
                   display "Checking RSS Feed ID: " counter                       
                   move counter to rss-feed-id
                   read rss-list-file into ws-rss-list-record
                       key is rss-feed-id
                       invalid key 
                           display "RSS Feed ID Not Found: " counter
                       not invalid key 
                           display "RSS Feed ID: " ws-rss-feed-id
                           display "  Data file: " ws-rss-dat-file-name
                           display "   Feed URL: " ws-rss-link

                   end-read       
                   display spaces
                   add 1 to counter                   
               end-perform
           close rss-list-file

           exit paragraph.           

       exit program.

