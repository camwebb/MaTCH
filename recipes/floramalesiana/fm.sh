#!/bin/sh

# Requires: java
#           saxon java XQuery engine
#           xmllint (from libxml2 XML library)

SAXONJAR="/home/cam/usr/Saxon/saxon9he.jar"

mkdir results
mkdir tmp

# 1. Get web pages and process to extract synonymy info
# As of 2016-07-05, the highest node is 16045

for i in $(seq 7177 7187)
do
    # Get the static, Drupal pages, one by one
    curl "http://portal.cybertaxonomy.org/flora-malesiana/node/"$i > tmp/raw.html
    # Clean the page so it can be queried with XQuery
    if [ `grep -c "<h2>Synonymy</h2>" tmp/raw.html` = 1 ]
    then
        xmllint --html --xmlout tmp/raw.html > tmp/clean.xml
        # Run the Xquery
        FILE=`printf "%05d" $i`
        java -cp $SAXONJAR net.sf.saxon.Query -q:extract.xq -s:tmp/clean.xml -o:results/$FILE
        rm -f tmp/*
    fi
done

rm -rf tmp

# 2. Process 

gawk 'BEGIN{
  x = 1;
  RS="\x04";
  cmd = "ls -1 results";
  cmd | getline filelist ;
  close(cmd);
  nfiles = split(filelist, file, "\n");
  for (i = 1; i < nfiles; i++) {
    print "file " file[i] > "/dev/stderr";
    cmd = "cat results/" file[i];
    cmd | getline text;
    close(cmd)
    gsub(/&amp;/,"\\&",text);
    nlines = split(text, line, "\n");
    accepted = x;
    print accepted "|" line[1] "|A|\\N" ;
    for (j = 3; j < nlines; j++) {
      if (line[j] != "") {
        print ++x "|" line[j] "|S|" accepted;
      }
    }
    x++;
  }
}' > fm_syns.csv

rm -rf results

# 3. Load data into MaTCH MySQL database:

mysql -u myuser -pmypassword match < load_fm_syns.sql


