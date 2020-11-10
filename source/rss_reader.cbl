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
               copy "./copybooks/filecontrol/rss_content_file.cbl".
               copy "./copybooks/filecontrol/rss_list_file.cbl".
               copy "./copybooks/filecontrol/rss_last_id_file.cbl".

       data division.
       file section.

           copy "./copybooks/filedescriptor/fd_rss_content_file.cbl".
           copy "./copybooks/filedescriptor/fd_rss_list_file.cbl".
           copy "./copybooks/filedescriptor/fd_rss_last_id_file.cbl".

       working-storage section.

       copy "./copybooks/wsrecord/ws-rss-record.cbl".
       copy "./copybooks/wsrecord/ws-rss-list-record.cbl".
       copy "./copybooks/wsrecord/ws-last-id-record.cbl".
       
       01 eof-sw                                   pic a value 'N'.
           88 eof                                   value 'Y'.
           88 not-eof                               value 'N'.
       
       

       77 counter                             pic 9(5) value 1.

       78 new-line                                 value x"0a".

      *> Temp placeholder. Will dynamically pull based on list file.
       78 ws-rss-content-file-name    value "./feeds/rss_00001.dat".
       78 ws-rss-list-file-name     value "./feeds/list.dat".
       78 ws-rss-last-id-file-name           value "./feeds/lastid.dat".



       procedure division.
       main-procedure.
           display "In RSS reader."

      *     open input rss-content-file
      *         perform until eof
      *             read rss-content-file into ws-rss-record
      *                 at end move 'Y' to eof-sw
      *             not at end
      *                 display function trim(ws-feed-title)
      *                 display function trim(item-title(1))
      *             end-read
      *         end-perform
      *     close rss-content-file

      *     display "End debug" new-line new-line

           perform load-highest-rss-record

           perform display-current-feeds

           goback.



       load-highest-rss-record.
                      
           move 'N' to eof-sw

      * make sure file exists... 
           open extend rss-last-id-file close rss-last-id-file

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
      * make sure file exists... 
           open extend rss-list-file close rss-list-file

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

