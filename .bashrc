# parallel is stupid
alias parallel='parallel --gnu'
# use mawk with tab delimiter for input and output
alias tawk='mawk -F "\t" -v OFS="\t"'
# use makw with pipe delimiter for input and output
alias pawk='mawk -F "|" -v OFS="|"'
# print numbered header of a TSV
alias theader="head -n 1 | tr '\t' '\n' | nl -ba | trim"
# NB: head is actually much faster than sed at taking the first line of large files
# also number blank lines - just in case
# relies on trim alias
# print numbered header of a CSV
alias cheader="head -n 1 | tr ',' '\n' | nl -ba | trim"
# print frequency of unique entries descending
alias sortfreq="sort | uniq -c | sort -k1 -rn | sed 's:^[ \t]\+::g;s:[ \t]\+$::g;s:^\([0-9]\+\) :\1\t:g'"
# bag of words
# doesn't quite work yet
alias bow="tr [:upper:] [:lower:] | tr '-' ' ' | tr \"'\" \" \" | tr -d [:punct:] | tr ' ' '\n' | sort | uniq"
# copy stdout to clipboard
alias clipboard="xclip -selection clip-board -i"
# make a list of awk columns eg "$1" from a list of numbers
alias awkcols="sed 's:^:$:g'|tr '\n' ','| sed 's:,$::g'"
## start TileMill - need to use right version of node
#alias tilemill="n use v0.8.17 /usr/share/tilemill/index.js"
# start tilemill
alias tilemill="/opt/tilemill/index.js"
# pipe IP addr to clipboard
alias getip="ifconfig -a |grep inet | grep -oE 'inet addr:[0-9.]+' | sed -n '1p' | grep -oE '[0-9.]+' | clipboard"

# for editing crontab
export EDITOR=vim

# yEd graph editor
alias yEd="/opt/yEd/yEd"

# trim leading and trailing whitespace
alias trim="sed 's:^[ \t]\+::g;s:[ \t]\+$::g'"

# convert xls(x)* to TSV
# requires gnumeric's ssconvert
function table2tsv { ssconvert --export-type Gnumeric_stf:stf_assistant -O 'separator="	"' fd://0 fd://1; }
export -f table2tsv

# list oldest files over 1GB in current dir
function listold { ls -c | tac | parallel -k 'du -b {} | mawk "{if(\$1 > 1073741824)print \$2}"'; }
export listold

# list all tables and fields in a psql db, tables in left col and their fields in right col, tab separated
function psql_listcols { echo "\d" | psql -d $1 | mawk -F'|' '{print $2}' | sed '1,3d' | grep -vE "^$" | parallel 'echo copy \(select \* from {} limit 0\) to stdout\ with csv header\; | psql -d '$1' | tr "," "\n" | sed "s:^:{}:g" | sed "s:^[ \t]\+::g;s:[ \t]\+$::g;s:[ \t]\+:\t:g"'; }
export psql_listcols

# prep to compare records field by field by translating their delimiters to newline and splitting them into individual files.  user must supply delimiter for tr, eg "," or "\t". typical use is to grep then pipe to this
# eg "grep -F '104665655' foo.csv | diff_prep , ; wdiff xx*"
function diff_prep { csvquote.awk | parallel 'echo {} | tr "'$1'" "\n" | nl -ba | sed "s:^[ \t]\+::g;s:[ \t]\+$::g" | sed "/^\$/d;\$G"' | sed '$d' | csplit - -s -z /^$/ {*}; }
export diff_prep

# get records from a txt that have text in columns beyond what they should have
# user args: 1) input txt to check, 2) number of columns the file should have, 3) delimiter
function cols_extra { incsv=$1; lastcol=$2; d=$3; cols=$( seq 1 $lastcol | tr '\n' ',' | sed 's:,$::g' ); cut --complement -d "$d" -f $cols $incsv | sed 's:[ \t]\+::g' | nl -ba | mawk '{if($2 !~ /^$/)print $1}' | parallel 'sed -n {}p '$incsv'' ;}
export cols_extra

# swap position of two columns in a TSV
# user args: 1) first col, 2) second col
# input TSV comes from stdin
function cols_swap { mawk -F'\t' " { OFS=\"\t\"; t = \$${1}; \$${1} = \$${2}; \$${2} = t; print; } "; }
export cols_swap

# find all files in working dir with a given extension
# essentially recursive "ls *.foo"
# example use: find_ext shp
function find_ext { find . -type f -iregex ".*[.]$1$"; }
export find_ext

# sum a column in awk.  don't use sci notation
# not actually sure I need printf here
# uses STDIN
function awksum { awk '{ sum += $1 } END { printf "%.4f\n", sum }' ; }
export awksum

# kill process using most memory
# add this as a keyboard shortcut for when box freezes
function kill_memhog { ps -e -o pid,vsz,comm= | sort -rn -k 2 | head -n 1 | awk '{print $1}' | xargs sudo kill -9; }
export kill_memhog

# mb-util from /opt/
alias 'mb-util'='/opt/mbutil/mb-util'

# weather-util - includes alerts
alias weather='weather -a -z va/VAC095,va/VAC199'

# print name of most recently modified file in dir
function latest { ls -c $1 | sed -n '1p' | sed 's:^:\":g;s:$:\":g'; }
export latest

# subset pdf by page number
# user args: 1) input pdf, 2) first page of subset, 3) last page of subset, 4) output pdf
function pdf_subset { gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=$2 -dLastPage=$3 -sOutputFile=$4 $1; }

# use a two column TSV to run sed substitution.
# all instances of column 1 (as words) will be replaced with column 2
# ignores header
function tsv_reclass { cat $1 | sed '1d' | awk -F'\t' '{OFS="\t";print "\\b"$1"\\b",$2}' | sed 's:\t:\::g;s:^:\::g;s:$:\::g;s:^:s:g;s:$:g:g' | tr '\n' ';' | sed 's:^:":g;s:$:":g;s:^:sed :g' | sed "s:$: $2:g"|sh ; }

# URL encode
function url_encode { perl -MURI::Escape -e 'print uri_escape($ARGV[0]); print "\n";' $1 ;}

# URL unencode
function url_unencode { perl -MURI::Escape -e 'print uri_unescape($ARGV[0]); print "\n";' $1 ;}

# HTML encode
# still getting 'wide character in print' message
function html_encode { perl -Mutf8 -MHTML::Entities -ne 'print encode_entities($_)'; }

# HTML decode
# still getting 'wide character in print' message
function html_decode { perl -Mutf8 -MHTML::Entities -ne 'print decode_entities($_)'; }

# return the count of non alpha / non digit characters sorted descending
function funky_chars { sed 's:\(.\):\1\n:g' | sort | uniq -c | sort -k1 -rn | tr -d '[:alpha:]' | awk '{if($2 !~ /^$/ && $2 !~ /[0-9]/)print $0}' ;}

# pipe file / text etc to this function to get a list of character encoding for each unique character
# output is two column TSV: the chardet output and the input character
# NB: this is character by character, and chardet sometimes guesses wrong this way - however, I'm less worried about comission than omission
function detect_chars { sed 's:\(.\):\1\n:g' | awk '{ print tolower( $0 ) }' | sort | uniq | parallel 'encoding=$( chardet <( echo {} ) ); echo -e $encoding"\t"{}' ;}
export detect_chars

# round to nearest user arg decimal
# eg 'cat foo.csv | round 0' to get whole numbers, and 'cat foo.csv | round 1' to round to first decimal place
function round { awk "{printf \"%3.$1f\n\", \$1}"; }

# open TSV with libreoffice calc
# libre is stupid
function libretsv { if [[ $( echo "$1" | grep -oE "[^.]*$" ) = "tsv" ]]; then libreoffice -calc $1; fi ;}
export function libretsv

# path to double metaphone from https://github.com/slacy/double-metaphone
alias double_metaphone='/opt/double-metaphone/dmtest'

# convert TSV to CSV - uses csvkit, assumes input is TSV
# also assumes max field size of no more than 1m characters
# ssconvert does not have these limit flags but it much slower
function table2csv { csvformat -t -z 1000000 $1;}
export table2csv

# write SQL to join an arbitrary number of tables to each other, given that they have a field of the same name to join on
# use double quoted list for table names
# example use: cat <( join_multi_w_singleField "1 2 3 4" example_field ) | psql db
# TODO: rename fields used to join according to the table they came from
function join_multi_w_singleField { field=$2; tables=( $1 ); num_elements=$( expr ${#tables[@]} - 1 ); for n in $(seq 0 $num_elements); do if [[ $n -eq $num_elements ]]; then false; elif [[ $n -eq 0 ]]; then echo "\"${tables[$n]}\" full outer join \"${tables[$( expr $n + 1 )]}\" on \"${tables[$n]}\".\"${field}\" = \"${tables[$( expr $n + 1 )]}\".\"${field}\""; unset tables[$n]; else echo "full outer join \"${tables[$( expr $n + 1 )]}\" on \"${tables[$n]}\".\"${field}\" = \"${tables[$( expr $n + 1 )]}\".\"${field}\""; unset tables[$n]; fi; done | tr '\n' ' ' | sed 's:^:select * from :g' ;}
export join_multi_w_singleField

# sort a TSV according to column names, using an arbitrary sort flag, eg -d or -n
# example use: col_sort -n in.tsv
# NB: relies on table2tsv, csvjoin, mawk
function col_sort { intsv=$2; cols_order=$( cat $intsv | head -n 1 | tr "\t" "\n" | nl -ba | sed 's:^[ \t]\+::g;s:[ \t]\+$::g' ); cols_sorted=$( echo "$cols_order" | mawk -F'\t' '{print $2}'|sort $1 | nl -ba | sed 's:^[ \t]\+::g;s:[ \t]\+$::g' ); cols_order=$( echo -e "col_num\tcol_name\n$cols_order"); cols_sorted=$( echo -e "col_num_new\tcol_name\n$cols_sorted" ); awk_print_order=$( csvjoin -t -c2,2 <( echo "$cols_order" ) <( echo "$cols_sorted" )|cut -d, --complement -f2,4|table2tsv |sort -k2,2 -n|cut -f1|sed '1d'|sed 's:^:$:g'|tr '\n' ','| sed 's:,$::g'); awk -F"\t" "{OFS=\"\t\";print $awk_print_order}" $intsv; };
export col_sort
