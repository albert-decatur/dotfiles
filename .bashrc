# parallel is stupid
alias parallel='parallel --gnu'
# use mawk with tab delimiter for input
alias tawk='mawk -F "\t"'
# remove interal commas that cause delimiter collision in a CSV
alias csvquote='mawk -f /usr/local/bin/csvquote.awk'
# print numbered header of a TSV
# NB: head is actually much faster than sed at taking the first line of large files
alias nheader='head -n 1 | tr "\t" "\n" | nl'
# print frequency of unique entries descending
alias sortfreq="sort | uniq -c | sort -k1 -rn | sed 's:^[ \t]\+::g;s:[ \t]\+$::g;s:^\([0-9]\+\) :\1\t:g'"
# bag of words
alias bow="tr [:upper:] [:lower:] | tr '-' ' ' | tr \"'\" \" \" | tr -d [:punct:] | tr ' ' '\n' | sort | uniq"
# copy stdout to clipboard
alias clipboard="xclip -selection clip-board -i"
# convert CSV to TSV
alias csv2tsv="csvquote | sed 's:\t::g;s:,:\t:g'"
# print name of most recently modified file in dir
alias latest="ls -c | sed -n '1p' | sed 's:^:\":g;s:$:\":g'"
# remove leading and trailing whitespace
alias rmwhite="sed 's:^[ \t]\+::g;s:[ \t]\+$::g'"
# make a list of awk columns eg "$1" from a list of numbers
alias awkcols="sed 's:^:$:g'|tr '\n' ','| sed 's:,$::g'"
# start TileMill - need to use right version of node
alias tilemill="n use v0.8.17 /usr/share/tilemill/index.js"
# pipe IP addr to clipboard
alias getip="ifconfig -a |grep inet | grep -oE 'inet addr:[0-9.]+' | sed -n '1p' | grep -oE '[0-9.]+' | clipboard"

# trim leading and trailing whitespace
alias trim="sed 's:^[ \t]\+::g;s:[ \t]\+$::g'"

# convert xls(x)* to TSV
# requires gnumeric's ssconvert
function xls2tsv { ssconvert --export-type Gnumeric_stf:stf_assistant -O 'separator="	"' $1 fd://1; }
export -f xls2tsv

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
# user args: 1) input txt to check, 2) number of columns the file should have
function cols_extra { incsv=$1; lastcol=$2; cols=$( seq 1 $lastcol | tr '\n' ',' | sed 's:,$::g' ); cut --complement -f $cols $incsv | sed 's:[ \t]\+::g' | nl -ba | mawk '{if($2 !~ /^$/)print $1}' | parallel 'sed -n {}p '$incsv'' ;}
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
function awksum { mawk '{ sum += $1 } END { printf "%.4f\n", sum }' ; }
export awksum
