      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-13
      * Last Modified: 2021-01-13
      * Purpose: Generates a report based on url of rss feed to file
      *          name provided.
      * Tectonics: ./build.sh
      ******************************************************************
       identification division.
       function-id. rss-report-writer.

       environment division.
       
       configuration section.

       repository.

       special-names.

       input-output section.
           file-control.                              
               copy "./copybooks/filecontrol/rss_list_file.cpy".
               copy "./copybooks/filecontrol/rss_content_file.cpy".

               select fd-report-file
               assign to dynamic ws-report-file-name
               organization is line sequential.

       data division.
       file section.
           copy "./copybooks/filedescriptor/fd_rss_list_file.cpy".
           copy "./copybooks/filedescriptor/fd_rss_content_file.cpy".

           fd fd-report-file
           report is r-rss-report.


       working-storage section.

       copy "./copybooks/wsrecord/ws-rss-list-record.cpy".
       copy "./copybooks/wsrecord/ws-rss-record.cpy".

       01  ws-rss-content-file-found-sw      pic x value 'N'.
           88  ws-content-file-found         value 'Y'.
           88  ws-content-file-not-found     value 'N'.

       01  ws-eof-sw                         pic x value 'N'.
           88  ws-eof                        value 'Y'.
           88  ws-not-eof                    value 'N'.

       01  ws-counter                        pic 99 value zeros.

       77  ws-report-file-name               pic x(512) 
                                             value "./report.txt".

       77  ws-rss-content-file-name          pic x(21) 
                                             value "./feeds/UNSET.dat".                                            
       78  ws-rss-list-file-name             value "./feeds/list.dat".

  
       linkage section.

       01  l-rss-link                          pic x any length.

       01  l-report-file-name                  pic x any length.
 
       01  l-create-report-status                pic 9 value zero.
           88  l-return-status-success           value 1.
           88  l-return-status-bad-param         value 2.
           88  l-return-status-not-found         value 3.


       report section.
           rd r-rss-report
           page limit is 68
           heading is 2
           first detail 3
           last detail 60
           footing 65. 

           01  r-report-header type report heading.
               05  line 2. 
                   10  column 2 pic x(5) value "PAGE:".
                   10  column 8 pic zz9 source page-counter.
                   10  column 30 
                       pic x(15) value "RSS REPORT - ".
                   10  column 44 pic x(35) source ws-feed-title.                       
               05  line plus 1.
                   10  column 25 pic x(50) value 
                   "--------------------------------------------------".
           01  r-id-line type detail line plus 1.
               05  column 8 pic x(3) value "Id:".
               05  column 12 pic 9(5) source ws-feed-id.
           01  r-title-line type detail line plus 1.
               05  column 5 pic x(6) value "Title:".
               05  column 12 pic x(59) source ws-rss-title.
           01  r-site-link-line type detail line plus 1.
               05  column 6 pic x(5) value "Site:".
               05  column 12 pic x(55) source ws-feed-site-link.
           01  r-feed-detail-line type detail line plus 1.
               05  column 4 pic x(7) value "Detail:".
               05  column 11 pic x(65) source ws-feed-desc(1:65).
           01  r-feed-detail-line-2 type detail line plus 1.
               05  column 15 pic x(65) source ws-feed-desc(66:65).
           01  r-item-line-1 type detail line plus 2.
               05  column 4 pic x(6) value "Items:".
           01  r-item-line-2 type detail line plus 1.
               05 column 4 pic x(6) value "------".
           01  r-item-title-line type detail line plus 1.
               05  column 4 pic x(6) value "Title:".
               05  column 11 pic x(70) source ws-item-title(ws-counter).
           01  r-publish-date-line type detail line plus 1.
               05  column 5 pic x(5) value "Date:".
               05  column 11 pic x(70) 
                   source ws-item-pub-date(ws-counter).    
           01  r-item-link-line type detail line plus 1.
               05  column 5 pic x(5) value "Link:".
               05  column 11 pic x(70) source ws-item-link(ws-counter).
           01  r-item-guid-line type detail line plus 1.
               05  column 5 pic x(5) value "Guid:".
               05  column 11 pic x(70) source ws-item-guid(ws-counter).
           01  r-item-desc-line-title type detail line plus 2.
               05  column 5 pic x(12) value "Description:".
           01  r-item-desc-line-1 type detail line plus 1.
               05  column 6 pic x(70) 
                   source ws-item-desc(ws-counter)(1:70).
           01  r-item-desc-line-2 type detail line plus 1.
               05  column 6 pic x(70) 
                   source ws-item-desc(ws-counter)(71:70).
           01  r-item-desc-line-3 type detail line plus 1.
               05  column 6 pic x(70) 
                   source ws-item-desc(ws-counter)(142:70).
           01  r-item-desc-line-4 type detail line plus 1.
               05  column 6 pic x(70) 
                   source ws-item-desc(ws-counter)(213:70). 
           01  r-item-desc-line-5 type detail line plus 1.
               05  column 6 pic x(70) 
                   source ws-item-desc(ws-counter)(284:70).
           01  r-item-desc-line-6 type detail line plus 1.
               05  column 6 pic x(70) 
                   source ws-item-desc(ws-counter)(355:70).
           01  r-item-desc-line-7 type detail line plus 1.
               05  column 6 pic x(70) 
                   source ws-item-desc(ws-counter)(426:70).       
           01  r-item-desc-line-8 type detail line plus 1.
               05  column 6 pic x(70) 
                   source ws-item-desc(ws-counter)(497:16).   
           01  r-item-end-line type detail line plus 2.    
               05 column 1 pic x(70) value spaces. 
               
                   

       screen section.        

       procedure division 
           using l-rss-link, l-report-file-name 
           returning l-create-report-status.
      
       main-procedure.

           if l-rss-link = spaces then 
               call "logger" using function concatenate(
                   "URL is required to create RSS report. No URL ",
                   "passed to rss-report-writer. Returning status 2.")
               end-call
               set l-return-status-bad-param to true 
               goback 
           end-if

           if l-report-file-name not equal spaces then 
               move l-report-file-name to ws-report-file-name
           else 
               call "logger" using function concatenate(
                   "No output file name passed ot report writer. Using",
                   " default file name: ", ws-report-file-name)
               end-call 
           end-if

           call "logger" using function concatenate(
               "Generating report for url: ", function trim(l-rss-link),
               " :: Output file name: ", 
               function trim(ws-report-file-name))
           end-call 
           
           perform set-rss-content-file-name

           if ws-content-file-not-found then 
               goback
           end-if 

           perform generate-rss-report

           set l-return-status-success to true 

           goback.

       
       set-rss-content-file-name.

           move l-rss-link to f-rss-link 
           open input fd-rss-list-file
                      
               read fd-rss-list-file into ws-rss-list-record
                   key is f-rss-link
                   invalid key 
                       call "logger" using function concatenate(
                           "Unable to find feed with feed url: ", 
                           f-rss-link, " : Cannot generate report.")
                       end-call 
                       set ws-content-file-not-found to true
                       
                   not invalid key                            
                       call "logger" using function concatenate(
                           "Report writer found RSS feed :: Title=", 
                           ws-rss-title)
                       end-call                           
                       move f-rss-dat-file-name 
                           to ws-rss-content-file-name
                       set ws-content-file-found to true                            
               end-read

           close fd-rss-list-file               

           exit paragraph.


       generate-rss-report.

           call "logger" using "Report generation started."

           initiate r-rss-report

           open input fd-rss-content-file
               read fd-rss-content-file into ws-rss-record
           close fd-rss-content-file

           move zeros to ws-counter
           move function trim(ws-rss-title) to ws-rss-title
           move function trim(ws-feed-site-link) to ws-feed-site-link
           
           open output fd-report-file
               generate r-id-line 
               generate r-title-line
               generate r-site-link-line
               generate r-feed-detail-line
               generate r-feed-detail-line-2
               generate r-item-line-1
               generate r-item-line-2 
               perform varying ws-counter from 1 by 1 
                   until ws-counter = ws-max-rss-items
                   if ws-item-exists(ws-counter) = 'Y' then 
                       generate r-item-title-line
                       generate r-publish-date-line
                       generate r-item-link-line 
                       generate r-item-guid-line
                       generate r-item-desc-line-title
                       generate r-item-desc-line-1  
                       if function length(
                           function trim(
                               ws-item-desc(ws-counter))) > 70 then 
                           generate r-item-desc-line-2
                       end-if
                       if function length(
                           function trim(
                               ws-item-desc(ws-counter))) > 140 then     
                           generate r-item-desc-line-3
                       end-if
                       if function length(
                           function trim(
                               ws-item-desc(ws-counter))) > 210 then      
                           generate r-item-desc-line-4
                       end-if
                       if function length(
                           function trim(
                               ws-item-desc(ws-counter))) > 280 then  
                           generate r-item-desc-line-5
                       end-if
                       if function length(
                           function trim(
                               ws-item-desc(ws-counter))) > 350 then  
                           generate r-item-desc-line-6
                       end-if
                       if function length(
                           function trim(
                               ws-item-desc(ws-counter))) > 420 then      
                           generate r-item-desc-line-7
                       end-if
                       if function length(
                           function trim(
                               ws-item-desc(ws-counter))) > 490 then                        
                           generate r-item-desc-line-8
                       end-if
                           
                       generate r-item-end-line 
                   end-if
               end-perform

           close fd-report-file

           terminate r-rss-report

           exit paragraph.


       end function rss-report-writer.
