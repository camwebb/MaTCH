# Getting standard botanical author abbreviations

In the taxonomic name string of plants, the ICBN
[recommends](https://en.wikipedia.org/wiki/List_of_botanists_by_author_abbreviation)
that an author’s name is abbreviated according to a list published by
[Brummitt & Powell 1992](https://en.wikipedia.org/wiki/Authors_of_Plant_Names)
(B&P).  I have yet (2016) to find a digitized version of B&P for
download, so I need to create one, primarily for the purpose of
matching author name strings in the merging of databases.  The scripts
in this directory extract author name information from IPNI, which has
a Standard Form of Author Names, which conforms (generally) to B&P (but see modern edits, such as [this](http://www.ipni.org/ipni/authorByVersion.do?id=893-1&version=1.2&show_history=true). Their [page](http://www.ipni.org/standard_forms_author.html) on the formation of standard forms is very useful.

Harvard Univ. Herbaria also maintain a separate [database of botanical authors](http://kiki.huh.harvard.edu/databases/botanist_index.html), which has a simple `json` web service. Unfortunately, the results from that service do not contain the B&P name. So it seems the only way to extract the data from this DB is to ask for the details of each page (the `json=y` option makes a [simpler](http://kiki.huh.harvard.edu/databases/botanist_search.php?mode=details&id=1943&json=y) HTML page to scrape), incrementing through several hundreds of thousands of pages. 
 
