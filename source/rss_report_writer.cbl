      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2021-01-13
      * Last Modified: 2021-09-23
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

       01  ws-counter                        pic 9(6) comp value zeros.

       01  ws-rss-content-file-found-sw      pic x value 'N'.
           88  ws-content-file-found         value 'Y'.
           88  ws-content-file-not-found     value 'N'.

       01  ws-eof-sw                         pic x value 'N'.
           88  ws-eof                        value 'Y'.
           88  ws-not-eof                    value 'N'.

       01  ws-date-record.
           05  ws-current-date.
               10  ws-year                   pic 9(4).
               10  ws-month                  pic 99.
               10  ws-day                    pic 99.
           05 ws-current-time.
               10  ws-hour                   pic 99.
               10  ws-min                    pic 99.
               10  ws-sec                    pic 99.
               10  ws-milli                  pic 99.
           05  ws-time-offset                pic S9(4).

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
           88  l-return-status-nothing-to-report value 3.
           88  l-return-status-data-file-missing value 4.          

       report section.
           rd r-rss-report
           page limit is 68
           heading is 2
           first detail 3
           last detail 60
           footing 65. 

           01  r-report-header type report heading.
               05  line 2.
                   10  column 1 
                       pic x(12) value "RSS REPORT -".
                   10  column 14 pic x(35) source ws-feed-title. 
               05  line plus 1.
                   10  column 1 pic x(5) value "DATE:".
                   10  column 7 pic x(40) source ws-date-record.   
               05  line plus 1.
                   10  column 1 pic x(5) value "PAGE:".
                   10  column 7 pic zz9 source page-counter.                   
               05  line plus 1.
                   10  column 1 pic x(50) value 
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

           01  r-feed-detail-line-1 type detail line plus 1.
               05  column 4 pic x(7) value "Detail:".
               05  column 11 pic x(65) source ws-feed-desc(1:65).
           01  r-feed-detail-line-2 type detail line plus 1.
               05  column 12 pic x(65) source ws-feed-desc(66:65).
           01  r-feed-detail-line-3 type detail line plus 1.
               05  column 12 pic x(65) source ws-feed-desc(131:65).  
           01  r-feed-detail-line-4 type detail line plus 1.
               05  column 12 pic x(65) source ws-feed-desc(196:60). 

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
               05  column 7 pic x(70) 
                   source ws-item-desc(ws-counter)(1:70).
           01  r-item-desc-line-2 type detail line plus 1.
               05  column 7 pic x(70) 
                   source ws-item-desc(ws-counter)(71:70).
           01  r-item-desc-line-3 type detail line plus 1.
               05  column 7 pic x(70) 
                   source ws-item-desc(ws-counter)(141:70).
           01  r-item-desc-line-4 type detail line plus 1.
               05  column 7 pic x(70) 
                   source ws-item-desc(ws-counter)(211:70). 
           01  r-item-desc-line-5 type detail line plus 1.
               05  column 7 pic x(70) 
                   source ws-item-desc(ws-counter)(281:70).
           01  r-item-desc-line-6 type detail line plus 1.
               05  column 7 pic x(70) 
                   source ws-item-desc(ws-counter)(351:70).
           01  r-item-desc-line-7 type detail line plus 1.
               05  column 7 pic x(70) 
                   source ws-item-desc(ws-counter)(421:70).       
           01  r-item-desc-line-8 type detail line plus 1.
               05  column 7 pic x(70) 
                   source ws-item-desc(ws-counter)(491:).   
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
               set l-return-status-data-file-missing to true 
               goback
           end-if 

           open input fd-rss-content-file
               read fd-rss-content-file into ws-rss-record
           close fd-rss-content-file

           if ws-num-items = 0 then 
               set l-return-status-nothing-to-report to true 
               call "logger" using function concatenate(
                   "Nothing to report. Number of items in RSS feed is ",
                   "currently zero. Exiting report generation with ",
                   "status code: 3")
               end-call

               goback 
           end-if 

           perform generate-rss-report

           call "logger" using "Report generation complete."
           set l-return-status-success to true 

           goback.

       
       set-rss-content-file-name.

           move l-rss-link to f-rss-link 
           call "logger" using function concatenate(
               "l-rss-link: ", l-rss-link, " f-rss-link: ", f-rss-link)
           end-call 
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

           call "logger" using function concatenate(
               "ws-rss-list-record: ", ws-rss-list-record)
           end-call 

           exit paragraph.
      
       

       generate-rss-report.

           call "logger" using "Report generation started."

           initiate r-rss-report

           move function current-date to ws-date-record
          
           move ws-num-items to ws-num-items-disp
           call "logger" using function concatenate( 
               "ws-num-items = " ws-num-items-disp)
           end-call 

           *> Counter must be initiated above zero before any report 
           *> generate calls are made as it's used as a table index 
           *> on the rss items. Reports with no items should be rejected
           *> in the main-method paragraph before reaching here.
           move 1 to ws-counter
           move function trim(ws-rss-title) to ws-rss-title
           move function trim(ws-feed-site-link) to ws-feed-site-link
           
           open output fd-report-file
               generate r-id-line 
               generate r-title-line
               generate r-site-link-line

               generate r-feed-detail-line-1

               if ws-feed-desc(66:65) not = spaces then  
                   generate r-feed-detail-line-2
               end-if
               if ws-feed-desc(131:65) not = spaces then  
                   generate r-feed-detail-line-3
               end-if    
               if ws-feed-desc(196:) not = spaces then  
                   generate r-feed-detail-line-4
               end-if    
                
               generate r-item-line-1
               generate r-item-line-2 
              
               perform varying ws-counter from 1 by 1 
               until ws-counter > ws-num-items
                 
                   generate r-item-title-line
                   generate r-publish-date-line
                   generate r-item-link-line 
                   generate r-item-guid-line
                   generate r-item-desc-line-title

                   if ws-item-desc(ws-counter)(1:70)
                       not = spaces then 
                       generate r-item-desc-line-1  
                   end-if 
                   if ws-item-desc(ws-counter)(71:70) 
                       not = spaces then
                       generate r-item-desc-line-2
                   end-if
                   if ws-item-desc(ws-counter)(141:70) 
                       not = spaces then     
                       generate r-item-desc-line-3
                   end-if
                   if ws-item-desc(ws-counter)(211:70) 
                       not = spaces then      
                       generate r-item-desc-line-4
                   end-if
                   if ws-item-desc(ws-counter)(281:70) 
                     not = spaces then  
                     generate r-item-desc-line-5
                   end-if
                   if ws-item-desc(ws-counter)(351:70) 
                       not = spaces then  
                       generate r-item-desc-line-6
                   end-if
                   if ws-item-desc(ws-counter)(421:70) 
                       not = spaces then      
                       generate r-item-desc-line-7
                   end-if
                   if ws-item-desc(ws-counter)(491:) 
                       not = spaces then                        
                       generate r-item-desc-line-8
                   end-if
                           
                   generate r-item-end-line 
                
               end-perform
               
           close fd-report-file

           terminate r-rss-report

           exit paragraph.


       end function rss-report-writer.
