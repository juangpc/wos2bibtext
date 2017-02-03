#wos2bibtex

Web_of_science to bibtext converter

#
This repository contains a single function written in Matlab. 
It is a function which translates a bilbiography as exported from Web of 
Science to a bibtex format which is then importable by most bibliographic 
applications like Mendeley, Zotero or many others.

IMPORTANT. At the moment it only works on windows. However I think that with
minimum changes it will be compatible with mac and linux/unix oss.

#Usage: 

Inside Web of Science Web application:

1. While searching different articles,books etc... select each interesting 
item and click on "add to Marked List" button.
2. Repeat 1. until the Marked List is full of relevant items.
3. Go to Marked List.
4. Go to Output Records. 
- Step 1. Select the records in the list to export. wos2bibtex has no limit.
- Step 2. Select de fields to export.
- Step 3. Select destination. 
          Select "Save to Other File Formats".
  A window will pop. Select File Format: Tab-delimited (Win). 
                   Otherwise it will not work!!

5. A text file will be created with name "savedrecs.txt".
6. Go to Matlab.
7. Make sure wos2bibtext is in your path and execute:

>>   wos2bibtext(file_in) 

with file_in being the complete path to the file obtained in step 5.

Finally another file with the same name as the input file will be 
created and in the same folder. This file will have .bib extension.

This final file will be importable by almost any bibliographic app.


Copyright (C) 2017 Juan Garcia-Prieto
contact: juangpc (at) gmail.com



