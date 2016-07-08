# Recipe to extract data from CDM Flora Malesiana DataPortal

Main script: `fm.sh`

The effort of the Flora Malesian Foundation and a team under [Walter Berendsohn](https://www.bgbm.org/de/personal/prof-dr-walter-g-berendsohn) to digitize existing volumes of FM provides an fundamental resource for managinf the names of SE Asian plants. The platform is the European [EDIT](http://cybertaxonomy.eu/) cybertaxonomy application which uses the Common Data Model for structuring taxonomic data. EDIT/CDN has an API, documented [here](http://cybertaxonomy.eu/cdmlib/rest-api-name-catalogue.html). This works well for the ‘test’ data-set, the Catologue of life (`col`). E.g.:

 * http://api.cybertaxonomy.org/col/taxon/656cc098-46a5-45f7-8bcb-74e30feec6af.xml`

API search endpoints are (e.g.):

 * http://api.cybertaxonomy.org/col/name_catalogue
 * http://api.cybertaxonomy.org/col/name_catalogue/name
 * http://api.cybertaxonomy.org/col/name_catalogue/taxon
 * http://api.cybertaxonomy.org/col/name_catalogue/accepted.xml?query=Barringtonia%20acutangula

However, as of 2016-07-07, the FM API is not fully working. The HTML portal works:

 * http://portal.cybertaxonomy.org/flora-malesiana/cdm_dataportal/taxon/70d2fa52-68da-4f64-9272-c3fc05af8812/synonymy

As does the API for basic info about taxon:

 * http://api.cybertaxonomy.org/flora-malesiana/taxon/70d2fa52-68da-4f64-9272-c3fc05af8812.xml

and names: 

 * http://api.cybertaxonomy.org/flora-malesiana/name/97ecf26b-42c7-4bc0-8b0e-9b82d9c59735.xml

But the search API that produces info on synonymy is not working:

 * http://api.cybertaxonomy.org/flora-malesiana/name_catalogue?query=Megadendron%20macrocarpum

Nor the taxon concept info:
 
 * http://api.cybertaxonomy.org/flora-malesiana/name_catalogue/taxon.xml?taxonUuid=70d2fa52-68da-4f64-9272-c3fc05af8812

----

So... the attached [script](fm.sh) uses page scraping. See the documentation within the script for further information.





