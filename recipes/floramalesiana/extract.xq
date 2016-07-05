declare option saxon:output 'omit-xml-declaration=yes';

concat(

  (: "accepted-name:",
  "&#10;", :)
  ( for $i in //div[h2='Synonymy']/div[@class="accepted-name"]
  return concat(
    $i//span[@class = "BotanicalName"]/span[@class="name"][1]/text(), "|", 
    $i//span[@class = "BotanicalName"]/span[@class="name"][2]/text(), "|", 
    $i//span[@class = "BotanicalName"]/span[@class="rank"][1]/text(), "|", 
    $i//span[@class = "BotanicalName"]/span[@class="name"][3]/text(), "|", 
    $i//span[@class = "BotanicalName"]/span[@class="authors"][1]/text(),"|",
    $i//span[@class = "reference"]/span[@class="reference"][1]/text()
         )
  ),
  "&#10;&#10;",

  (: mixing homotypic, heterotypic, and homotypic-of-heterotypic :)
  (: "synonyms:", 
  "&#10;", :)
  string-join(
  ( for $i in //div[h2='Synonymy']/div[contains(@class, "synonymy-group")]//li[@class = "synonym" or @class = "firstentry synonym"]
  return concat(
    $i//span[@class = "BotanicalName"]/span[@class="name"][1]/text(), "|", 
    $i//span[@class = "BotanicalName"]/span[@class="name"][2]/text(), "|", 
    $i//span[@class = "BotanicalName"]/span[@class="rank"][1]/text(), "|", 
    $i//span[@class = "BotanicalName"]/span[@class="name"][3]/text(), "|", 
    $i//span[@class = "BotanicalName"]/span[@class="authors"][1]/text(),"|",
    $i//span[@class = "reference"]/span[@class="reference"][1]/text()
         )
  ),
  "&#10;"),
  "&#10;"
)  



(: string-join :)

(:   ( for $i in //div[h2='Synonymy']/div[@class="homotypic-synonymy-group"]//li[@class="synonym"]//span[@class = "BotanicalName"] :)
