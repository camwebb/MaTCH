#!/bin/gawk -f

BEGIN{
  FS = "|";
  OFS= "|";
  
  
  # CONFIG
  PL = "../theplantlist/data/tpl.csv" ;
  # Column order
  PL_code = 1; PL_f = 3   ; PL_xg = 4 ; PL_g = 5  ; PL_xs = 6 ; PL_s = 7;
  PL_st = 8;   PL_ssp = 9 ; PL_a = 10 ; PL_status = 11 ; PL_syn = 12 

  IN = "./names.csv" ;
  # Column order
  IN_code = 1; IN_xg = 2 ; IN_g = 3  ; IN_xs = 4 ; IN_s = 5;
  IN_st = 6;   IN_ssp = 7 ; IN_a = 8 ; 

  # STEP 0. Read data
  
  print "Reading ThePlantList..." > "/dev/stderr";
  while ((getline < PL) > 0) {
    PLdata[$PL_code] = $0;
    PLg[$PL_code] = $PL_g ;
    PLglist[$PL_g] = 1;
    PLgsaStr[$PL_code] = $PL_xg " " $PL_g " " $PL_xs " " $PL_s " "  \
      $PL_st " " $PL_ssp " " $PL_a ;
    gsub(/\ \ */," ",PLgsaStr[$PL_code]);
    gsub(/\ *$/,"",PLgsaStr[$PL_code]);
    gsub(/^\ */,"",PLgsaStr[$PL_code]);
    gsakey = $PL_xg $PL_g $PL_xs $PL_s   \
      gensub(/\./,"","G",$PL_st) $PL_ssp        \
      tolower(gensub(/[ .]/,"","G",$PL_a));
    PLgsakey[$PL_code] = gsakey;
    PLcode[gsakey] = $PL_code;
    PLsyn[$PL_code] = $PL_syn;
  }
  print "Done.\n"> "/dev/stderr";

  print "Reading your names list..." > "/dev/stderr";  
  while ((getline < IN) > 0) {
    # INdata[++inputorder] = $0;
    INcode[++inputorder] = $IN_code ;
    INg[inputorder] = $IN_g ;
    INgsaStr[inputorder] = $IN_xg " " $IN_g " " $IN_xs " " $IN_s " " \
      $IN_st " " $IN_ssp " " $IN_a ;
    gsub(/\ \ */," ", INgsaStr[inputorder]);
    gsub(/\ *$/,"",INgsaStr[inputorder]);
    gsub(/^\ */,"",INgsaStr[inputorder]);
    INglist[$IN_g] = 1;
    INgsakey[inputorder] = $IN_xg $IN_g $IN_xs $IN_s \
      gensub(/\./,"","G",$IN_st) $IN_ssp \
      tolower(gensub(/[ .]/,"","G",$IN_a));
    # INcode[gsakey] = $IN_code;
  }
  print "  Done.\n" > "/dev/stderr";

  # STEP 1. checking genera

  print "Checking genera..." > "/dev/stderr";
  for (i in INglist) {
    if (!PLglist[i])                                                    \
      print "Genus missing (no further matching):" i > "/dev/stderr";
    INgNotPL[i] = 1;
  }
  print "  Done.\n" > "/dev/stderr";

  # STEP 2. try simple matching
  print "Simple matching..." > "/dev/stderr";
  for (i = 1 ; i <= inputorder ; i++) {
    if (PLcode[INgsakey[i]]) {
      INmatched[i] = 1; 
      print INcode[i] , PLdata[PLcode[INgsakey[i]]] > "names.simplematch.csv"
    }
    else {
      # prepare the genus sublists for agrep matching
      makegenus[INg[i]] = 1;
    }
  }
  print "  Done.\n" > "/dev/stderr";

  # STEP 3. make sublists, for agrep
  system("mkdir tmp_genera");
  for (i in PLdata) {
    if (makegenus[PLg[i]]) {  # note: this does not find taxa not in PL!
      print i " " PLgsakey[i]  >> "tmp_genera/" PLg[i] ".csv" ;
      close("tmp_genera/" PLg[i] ".csv");
    }
  }

  # STEP 4. try agrep matching on species name
  for (i = 1 ; i <= inputorder ; i++) {
    if (!INmatched[i]) {
      cmd = "agrep -k -2 '" INgsakey[i] "' tmp_genera/" INg[i] ".csv";
      agreps = "";
      RS = "\x04";
      cmd | getline agreps;
      close(cmd);
      RS = "\n";
      if (length(agreps) > 1) {
        na = split(agreps, a, "\n");
        for (j = 1; j < na; j++) {
          split(a[j],b," ");
          print INcode[i], INgsaStr[i], PLgsaStr[b[1]], b[1] > "names.manual.csv";
        }

      }
    }
  }

  
    
    

  
  exit;
}






#   while ((getline < IN) > 0) INglist[$IN_g] = 1;
#   for (i in INglist) {
#     if (!PLglist[i]) print "Genera 
  
#   FS="|";
#   # read in the plant list
#   while ((getline < \
#           "/home/cam/public_html/xabi/tools/theplantlist/data/tpl.csv") > 0) {
#     data[$1] = $0;
#     gs[$5 "|" $7] = gs[$5 "|" $7] "|" $1;
#   }

#   # make agrep list
#   #for (i in gs) print i > "_agreplist" ;
#   #close("_agreplist");

#   # read in lookup list
#   while ((getline < ARGV[1]) > 0) {
#     found = 0;
#     gsub(/NULL/,"",$0);
#     gsub(/\ /,"",$2); # fix spaces
#     gsub(/cf[ .]/,"",$3);
#     gsub(/\ /,"",$3);
#     gsub(/\ /,"",$5);
#     print $2 " " $3 " " $4 " " $5 " " $6;

#     # does the genus and species not match?
#     if (!gs[$2 "|" $3]) {
#       # print "  not found";
#       print "  trying spelling...";
#       cmd = "agrep -k -2 '" $2 "|" $3 "' _agreplist";
#       agreps = "";
#       RS = "\x04";
#       cmd | getline agreps;
#       close(cmd);
#       RS = "\n";
#       if (length(agreps) > 1) {
#         print "  choose one:" ;
#         na = split(agreps, a, "\n");
#         for (i = 1; i < na; i++) print "  " i ". " a[i];
#         getline answer < "/dev/tty";
#         close("/dev/tty");
#         gsub(/\n/,"",answer);
#         if ((answer > 0) && (answer < na)) {
#           split(a[answer], a2, "|");
#           $2 = a2[1]; $3 = a2[2]; # replace
#         }
#         else found = 1;
#         # and move on
#       }
#       else found = 1;
#     }
#     if (!found) {
#       n = split(gs[$2 "|" $3], x, "|");
#       for (i = 2; i <= n; i++) {
#         split(data[x[i]], d, "|");
#         # do g+s+a match with no ssp?
#         # with fuzzy author
#         if (($2 == d[5]) &&   \
#             ($3 == d[7]) &&   \
#             ($4 == d[8]) &&   \
#             ($5 == d[9]) &&                  \
#             (tolower(gensub(/[(). ]/,"","G",$6)) == \
#              tolower(gensub(/[(). ]/,"","G",d[10])))) {
#           print "  g+s+a: " d[1];
#           print $1 "|" $2 "|" $3 "|" $6 "|tpl_gsa|" d[1] >> "out"; close("out");
#           found =1;
#           break;
#         }
#       }
#       if (!found) {
#         for (i = 2; i <= n; i++) {
#           split(data[x[i]], d, "|");
#           print "    " i-1 ". " d[5] " " d[7] " " d[8] " " d[9] " " \
#             d[10] " ["  substr(d[11],1,1) "]";
#         }
#         getline answer < "/dev/tty";
#         close("/dev/tty");
#         gsub(/\n/,"",answer);
#         type = "tpl_man+"; 
#         if (answer == "x") {
#           type = "tpl_man-";
#           getline answer < "/dev/tty";
#           close("/dev/tty");
#           gsub(/\n/,"",answer);
#         }
#         if ((answer > 0) && (answer < n)) {
#           # add test **
#           split(data[x[answer+1]], d, "|");
#           print "  choice: " d[1];
#           print $1 "|" $2 "|" $3 "|" $6 "|" type "|" d[1] >> \
#             "out"; close("out");
#           found =1;
#         }
#         else {
#           print "  skipping...";
#           print $1 "|" $2 "|" $3 "|" $6 "|not_found|" >> "out"; close("out");
#         }
#       }
#     }
#     print "";
#   }
# }
