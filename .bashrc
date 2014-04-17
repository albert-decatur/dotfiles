# copy stdout to clipboard
alias clipboard="xclip -selection clip-board -i"
# lock and blank screen
alias lock='gnome-screensaver-command --lock'
# GNU parallel is stupid
alias parallel='parallel --gnu'
# use gawk with tabs as input field delimiter
alias tawk='gawk -F "\t"'
# remove interal commas that cause delimiter collision in a CSV
alias csvquote='awk -f /usr/local/bin/csvquote.awk'
# print numbered header of a TSV
alias nheader='sed -n "1p" | tr "\t" "\n" | nl'
# print frequency of unique entries, sort descending
alias sortfreq='sort | uniq -c | sort -k1 -rn'
# bag of words
alias bow="tr [:upper:] [:lower:] | tr '-' ' ' | tr \"'\" \" \" | tr -d [:punct:] | tr ' ' '\n' | sort | uniq"
# convert CSV to TSV
alias csv2tsv="csvquote | sed 's:\t::g;s:,:\t:g'"
# print name of most recently modified file in current dir
alias latest="ls -c | sed -n '1p' | sed 's:^:\":g;s:$:\":g'"
# start TileMill - need to use right version of node
alias tilemill="n use v0.8.17 /usr/share/tilemill/index.js"
# pipe localhost IP addr to clipboard
alias getip="ifconfig -a |grep inet | grep -oE 'inet addr:[0-9.]+' | sed -n '1p' | grep -oE '[0-9.]+' | clipboard"
# trim leading and trailing whitespace
alias trim="sed 's:^[ \t]\+::g;s:[ \t]\+$::g'"

# convert xls(x)* to TSV
# requires gnumeric's ssconvert
function xls2tsv { ssconvert --export-type Gnumeric_stf:stf_assistant -O 'separator="	"' $1 fd://1; }
export -f xls2tsv

# list oldest files over 1GB in current dir
function listold { ls -c | tac | parallel -k 'du -b {} | awk "{if(\$1 > 1073741824)print \$2}"'; }
export listold

# list all tables and fields in a psql db, tables in left col and their fields in right col, tab separated
function psql_listcols { echo "\d" | psql -d $1 | awk -F'|' '{print $2}' | sed '1,3d' | grep -vE "^$" | parallel 'echo copy \(select \* from {} limit 0\) to stdout\ with csv header\; | psql -d '$1' | tr "," "\n" | sed "s:^:{}:g" | sed "s:^[ \t]\+::g;s:[ \t]\+$::g;s:[ \t]\+:\t:g"'; }
export psql_listcols

# prep to compare records field by field by translating their delimiters to newline and splitting them into individual files.
# user must supply delimiter for tr, eg "," or "\t". typical use is to grep or awk then pipe to this
# numbers fields in each record
# eg "grep -F '104665655' foo.csv | diff_prep , ; wdiff xx*"
function diff_prep { csvquote.awk | parallel 'echo {} | tr "'$1'" "\n" | nl -ba | sed "s:^[ \t]\+::g;s:[ \t]\+$::g" | sed "/^\$/d;\$G"' | sed '$d' | csplit - -s -z /^$/ {*}; }
export diff_prep
