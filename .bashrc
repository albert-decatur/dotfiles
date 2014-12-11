# set vim as default editor
export EDITOR=vim
# vim style keybindings for bash
set -o vi
# use pygmentize when running 'less foo' but not 'cat foo | pygmentize | less -r', which gets messed up
export LESSOPEN='|pygmentize %s'

# print name of most recently modified file in dir
function latest { ls -c $1 | sed -n '1p' | sed 's:^:\":g;s:$:\":g'; }
export latest
# list oldest files over 1GB in current dir
function listold { find . -size +1G -printf "%p\t%k\t%TY-%Tm-%Td\n" | sort -k3,3 -t'	' -n | awk -F'\t' '{print $1}'; }
export listold
# copy stdout to clipboard
alias clipboard="xclip -selection clip-board -i"
# subset pdf by page number
# user args: 1) input pdf, 2) hyphen separated page range, 3) output pdf
# example use pdf_subset in.pdf 1-10 out.pdf
function pdf_subset { pdftk A=$1 cat A$2 output $3; }
# cat TSV to this and output github flavored markdown table
function tsv2githubmd { in=$(cat); col_count=$(echo "$in" | awk -F'\t' '{print NF}' | sed -n '1p' ); second_line=$( yes -- --- | head -n $col_count | tr '\n' '|' | sed 's:|$::g' ); echo "$in" | sed "1 a\\$second_line" | sed 's:\t:|:g'; };
export tsv2githubmd
# GNU parallel is stupid
alias parallel='parallel --gnu'
# use mawk with tab delimiter for input and output
alias tawk='mawk -F "\t" -v OFS="\t"'
# use makw with pipe delimiter for input and output
alias pawk='mawk -F "|" -v OFS="|"'
# print numbered header of a TSV
alias theader="head -n 1 | tr '\t' '\n' | nl -ba | sed 's:^[ \t]\+::g;s:[ \t]\+$::g'"
# print numbered header of a CSV
alias cheader="head -n 1 | tr ',' '\n' | nl -ba | sed 's:^[ \t]\+::g;s:[ \t]\+$::g'"
# convert Gnumeric-recognized tables to TSV
# more generic than csvformat from csvkit but slower
# requires gnumeric's ssconvert
function table2tsv { ssconvert --export-type Gnumeric_stf:stf_assistant -O 'separator="	"' fd://0 fd://1; }
export -f table2tsv
# convert TSV to CSV - uses csvkit, assumes input is TSV
# also assumes max field size of no more than 1m characters
# ssconvert does not have these limit flags but it much slower
function table2csv { csvformat -t -z 1000000 $1;}
export table2csv
# print frequency of unique entries descending
alias sortfreq="sort | uniq -c | sort -k1 -rn | sed 's:^[ \t]\+::g;s:[ \t]\+$::g;s:^\([0-9]\+\) :\1\t:g'"
# return the count of non alpha / non digit characters sorted descending
function funky_chars { sed 's:\(.\):\1\n:g' | sort | uniq -c | sort -k1 -rn | tr -d '[:alpha:]' | awk '{if($2 !~ /^$/ && $2 !~ /[0-9]/)print $0}' ;}
# trim leading and trailing whitespace
alias trim="sed 's:^[ \t]\+::g;s:[ \t]\+$::g'"
# round to nearest user arg decimal
# eg 'cat foo.csv | round 0' to get whole numbers, and 'cat foo.csv | round 1' to round to first decimal place
function round { awk "{printf \"%3.$1f\n\", \$1}"; }
# sum a column in awk.  don't use sci notation
# uses STDIN
function awksum { awk '{ sum += $1 } END { printf "%.4f\n", sum }' ; }
export awksum
# get records from a txt that have text in columns beyond what they should have
# user args: 1) input txt to check, 2) number of columns the file should have, 3) delimiter
function col_extra { incsv=$1; lastcol=$2; d=$3; cols=$( seq 1 $lastcol | tr '\n' ',' | sed 's:,$::g' ); cut --complement -d "$d" -f $cols $incsv | sed 's:[ \t]\+::g' | nl -ba | mawk '{if($2 !~ /^$/)print $1}' | parallel 'sed -n {}p '$incsv'' ;}
export col_extra
# swap position of two columns in a TSV
# user args: 1) first col, 2) second col
# input TSV comes from stdin
function col_swap { mawk -F'\t' " { OFS=\"\t\"; t = \$${1}; \$${1} = \$${2}; \$${2} = t; print; } "; }
export col_swap
# sort a TSV according to column names, using an arbitrary sort flag, eg -d or -n
# example use: col_sort -n in.tsv
# NB: relies on table2tsv, csvjoin, mawk
function col_sort { intsv=$2; cols_order=$( cat $intsv | head -n 1 | tr "\t" "\n" | nl -ba | sed 's:^[ \t]\+::g;s:[ \t]\+$::g' ); cols_sorted=$( echo "$cols_order" | mawk -F'\t' '{print $2}'|sort $1 | nl -ba | sed 's:^[ \t]\+::g;s:[ \t]\+$::g' ); cols_order=$( echo -e "col_num\tcol_name\n$cols_order"); cols_sorted=$( echo -e "col_num_new\tcol_name\n$cols_sorted" ); awk_print_order=$( csvjoin -t -c2,2 <( echo "$cols_order" ) <( echo "$cols_sorted" )|cut -d, --complement -f2,4|table2tsv |sort -k2,2 -n|cut -f1|sed '1d'|sed 's:^:$:g'|tr '\n' ','| sed 's:,$::g'); awk -F"\t" "{OFS=\"\t\";print $awk_print_order}" $intsv; };
export col_sort
# make a string for awk-style column printing ( eg "$1,$2" ) from a list of numbers
alias awkcols="sed 's:^:$:g'|tr '\n' ','| sed 's:,$::g'"
# list all tables and fields in a psql db, tables in left col and their fields in right col, tab separated
function psql_listcols { echo "\d" | psql -d $1 | mawk -F'|' '{print $2}' | sed '1,3d' | grep -vE "^$" | parallel 'echo copy \(select \* from {} limit 0\) to stdout\ with csv header\; | psql -d '$1' | tr "," "\n" | sed "s:^:{}:g" | sed "s:^[ \t]\+::g;s:[ \t]\+$::g;s:[ \t]\+:\t:g"'; }
export psql_listcols
# find all files in working dir with a given extension
# essentially recursive "ls *.foo"
# example use: find_ext shp
function find_ext { find . -type f -iregex ".*[.]$1$"; }
export find_ext
# URL encode
function url_encode { perl -MURI::Escape -e 'print uri_escape($ARGV[0]); print "\n";' $1 ;}
# URL unencode
function url_decode { perl -MURI::Escape -e 'print uri_unescape($ARGV[0]); print "\n";' $1 ;}
# HTML encode
# still getting 'wide character in print' message
function html_encode { perl -Mutf8 -MHTML::Entities -ne 'print encode_entities($_)'; }
# HTML decode
# still getting 'wide character in print' message
function html_decode { perl -Mutf8 -MHTML::Entities -ne 'print decode_entities($_)'; }
# open TSV with libreoffice calc
# libre is stupid
function libretsv { if [[ $( echo "$1" | grep -oE "[^.]*$" ) = "tsv" ]]; then libreoffice --calc $1; fi ;}
export function libretsv
# use GNUplot to plot a single column of values, inspired by jeroenjanssens
# assumed a header, sorts numeric ascending
function dumbplot { sed '1d' | sort -n | nl | gnuplot -e 'set term dumb; set datafile separator "\t"; plot "-"' ;}
export dumbplot
# write SQL to join an arbitrary number of tables to each other, given that they have a field of the same name to join on
# use double quoted list for table names
# example use: join_multi_w_singleField "1 2 3 4" example_field db
function join_multi_w_singleField { field=$2; tables=( $1 ); header=$( echo $1 | sed 's:\s\+:\t:g' ); num_elements=$( expr ${#tables[@]} - 1 ); for n in $(seq 0 $num_elements); do if [[ $n -eq $num_elements ]]; then false; elif [[ $n -eq 0 ]]; then echo "\"${tables[$n]}\" full outer join \"${tables[$( expr $n + 1 )]}\" on \"${tables[$n]}\".\"${field}\" = \"${tables[$( expr $n + 1 )]}\".\"${field}\""; unset tables[$n]; else echo "full outer join \"${tables[$( expr $n + 1 )]}\" on \"${tables[$n]}\".\"${field}\" = \"${tables[$( expr $n + 1 )]}\".\"${field}\""; unset tables[$n]; fi; done | tr '\n' ' ' | sed 's:^:select * from :g' | sed "s:^:copy (:g;s:$:) to stdout with delimiter E'\t' csv header:g" | psql $3 | sed '1d' | sed "1 s/^/$header\n/g";}
export join_multi_w_singleField
# get a count of unique entries in every field in a TSV
function uniqvals { intsv=$1; header=$(cat $intsv | head -n 1); nfields=$( echo "$header" | tr '\t' '\n' | wc -l ); for field in $(seq 1 $nfields); do cat $intsv | sed '1d' | mawk -F'\t' "{print \$$field}" | sort | uniq -c | sort -k1 -rn > /tmp/${field}; done; echo "$header"; paste -d'\t' $(seq 1 $nfields | sed 's:^:/tmp/:g'); }
export uniqvals
# kill processes by name - more than pkill!
# example killname chrome
function killname { ps aux | grep $1 | awk '{print $2}' | xargs -I '{}' kill -9 {} ;}
export killname
