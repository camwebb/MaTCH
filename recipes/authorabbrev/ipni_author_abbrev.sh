
# 1. Get the data from IPNI, bite-size, via wildcard search on each letter.

mkdir build
for l in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
do
   curl -L "http://www.ipni.org/ipni/advAuthorSearch.do?find_forename=&find_surname=$l*&output_format=delimited-minimal&query_type=by_query" > build/$l.csv
done

# 2. eliminate duplicates and output

cd build
cat *csv > all.csv
gawk 'BEGIN{FS="%";OFS="|"} {key = $1 $2 ; short[key] = $3; first[key] = $4; sur[key] = $5} END{for (i in short) print short[i], first[i], sur[i]}' all.csv | sort -t "|" -k 1 > ../ipni_author_abbrev.csv

# 3. clean up

rm -rf build
