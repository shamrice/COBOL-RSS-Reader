      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2020-11-10
      * Purpose: RSS Reader Feed Viewer - Displays formatted feed data
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       program-id. rss-reader-view-feed.

       environment division.
       
       configuration section.

       input-output section.
           file-control.               
               copy "./copybooks/filecontrol/rss_content_file.cpy".
               copy "./copybooks/filecontrol/rss_list_file.cpy".
               copy "./copybooks/filecontrol/rss_last_id_file.cpy".

       data division.
       file section.

           copy "./copybooks/filedescriptor/fd_rss_content_file.cpy".
           copy "./copybooks/filedescriptor/fd_rss_list_file.cpy".
           copy "./copybooks/filedescriptor/fd_rss_last_id_file.cpy".

       working-storage section.

       copy "./copybooks/wsrecord/ws-rss-record.cpy".
       copy "./copybooks/wsrecord/ws-rss-list-record.cpy".
       copy "./copybooks/wsrecord/ws-last-id-record.cpy".

       01 eof-sw                                   pic a value 'N'.
           88 eof                                   value 'Y'.
           88 not-eof                               value 'N'.
       
       

       77 counter                             pic 9(5) value 1.

       78 new-line                                 value x"0a".

      *> Temp placeholder. Will dynamically pull based on list file.
       78 ws-rss-content-file-name    value "./feeds/rss_00001.dat".
       78 ws-rss-list-file-name     value "./feeds/list.dat".
       78 ws-rss-last-id-file-name           value "./feeds/lastid.dat".

       copy "screenio.cpy".

       screen section.

       procedure division.
       main-procedure.
           goback.

       end program rss-reader-view-feed.
