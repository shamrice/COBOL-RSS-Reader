      ******************************************************************
      * Author: Erik Eriksen
      * Create Date: 2020-11-10
      * Last Modified: 2021-01-12
      * Purpose: File control definition for data file that stores last
      *          ID retreived and saved.
      * Tectonics: ./build.sh
      ******************************************************************
               select optional fd-rss-last-id-file
               assign to dynamic ws-rss-last-id-file-name
               organization is line sequential.
