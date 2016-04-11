#!/bin/sh

## Recipe to download and clean the Plant List (v 1.1)

# # 1. Download the page with a list of genera 

# mkdir data
# curl "http://www.theplantlist.org/1.1/browse/-/-/" > data/genus_list.html

# # 2a. Extract the genera from the web page

# grep -E '.*genus">' data/genus_list.html | \
#     sed -e 's|^.*/"><i\ class="||g' \
#         -e 's/\ genus">/ /g' \
#         -e 's|</i></a>\ (<i\ class="family">| |g' \
#         -e 's|</i>.*||g' \
#         -e 's/×&nbsp;//g' > data/genus_list

# # 2b. Get unique genus names (multiples present due to i. Unresolved
# #     taxonomy and ii. diff domains, e.g., Cedrus in angio and gymno)

# gawk '{g[$2]++}END{for(i in g) print i}' data/genus_list | sort > \
#     data/genus_list_unique

# # 3. Create a download script

# mkdir data/genera
# # (remove the hybrid marks)
# cat data/genus_list_unique | sed -e 's/×\ //g' \
#     -e 's|\(.*\)|echo "\1"; curl -s "http://www.theplantlist.org/tpl1.1/search?q=\1\&csv=true" > data/genera/\1.csv|g' > data/download.sh

# # 4. Run the script (use nohup if sshing into another 'download' machine)
# sh data/download.sh

# # 5. Combine and exctract just fields needed
# cat data/genera/* >> data/all.csv
# sed -i -e '/^.*Major\ group,Family.*$/d' data/all.csv

# # ID,Major group,Family,Genus hybrid marker,Genus,Species hybrid marker,Species,Infraspecific rank,Infraspecific epithet,Authorship,Taxonomic status in TPL,Nomenclatural status from original data source,Confidence level,Source,Source id,IPNI id,Publication,Collation,Page,Date,Accepted ID

# gawk 'BEGIN{
#   FPAT = "([^,]*)|(\"[^\"]+\")";
#   OFS="|"; 
# }
# {
#   for (i = 1; i <= NF; i++) {
#     if (substr($i, 1, 1) == "\"") {
#       $i = substr($i, 2, length($i) - 2)
#     }
#   }
#   print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $21;
# }' data/all.csv > data/tpl.csv
#
# wc data/tpl.csv

# # 6. Add genus and family codes

gawk 'BEGIN{ FS="|"; OFS="|"; }
  {
    f[$5 $4]=$3; g[$5 $4] = $5; h[$5 $4]=$4; 
    if ($3) { F[$3]++; c[$3]=$2; } # there are a few family-less taxa
  }
  END {
    n = asorti(f, f2);
    for (x = 1; x <= n; x++) { 
      print "tplg-" x , c[f[f2[x]]], f[f2[x]], h[f2[x]] , g[f2[x]] "|||||||";
    }
    n = asorti(F);
    for (x = 1; x <= n; x++) {
      print "tplf-" x , c[F[x]], F[x] "|||||||||";
    }
  }' data/tpl.csv > data/f+g.csv

# 7. Done!

cat data/tpl.csv data/f+g.csv > tpl.csv

# cleanup

bzip2 tpl.csv

# rm -rf data
