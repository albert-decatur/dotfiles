dotfiles
========

Bash (or zsh!) functions for data science.  
Check dpkg.md for a list of apt packages that are awesome.
On a Debian based system (like Ubuntu!) you can

```bash
sudo apt-get update && sudo apt-get install $( cat dpkg.md | sed 's:*.*\|#.*::g' | grep -vE "^\s" | tr '\n' ' ' )
```

function|purpose|example|prerequisite
---|---|---|---
latest|print the name of the most recently modified file in the current directory|latest|
listold|list the oldest files over _n_ MB in current directory|listold 100|[parallel](http://www.gnu.org/software/parallel/),[mawk](http://invisible-island.net/mawk/)
maybedups|prints TSV of *possible* file duplicates of largest _n_ files under current directory. NB: files might *not* be duplicates but it's fast|maybedups 10 \| csvlook -t \| vim -|tawk
clipboard|pipe text to clipboard|cat foo \| clipboard|[xclip](http://sourceforge.net/projects/xclip/)
pdf_subset|take a page range from a PDF|pdf_subset in.pdf 23-41 out.pdf|[pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)
ngrams|get ngrams of length *n* from a column, treating records as documents| cat foo.tsv \| cut -f3 \| ngrams 2 |
plotbars|use ggplot to make PNG bar graph of a TSV. high res an option!|cat foo.tsv \| tawk '{print $2}' \| sortfreq \| sortkh "-k2 n" \| plotbars year count "title" 20 \| feh - |ggplot2,[Rio](https://github.com/jeroenjanssens/data-science-at-the-command-line)
dumbplot|use GNUplot to graph one or two numeric fields in the terminal. removes header if found. assumes should graph points but can graphs lines. inspired by jeroenjanssens| cat foo.tsv \| cut -f3,4 \| dumbplot OR cat foo.tsv \| cut -f4 \| dumbplot lines |[gnuplot](http://www.gnuplot.info/download.html)
table2tsv|convert any Gnumeric compatible table to TSV|cat foo.csv \| table2tsv|[Gnumeric](http://www.gnumeric.org/)
table2csv|convert any CSVKit compatible table to CSV|cat foo.tsv \| table2csv|[csvkit](https://csvkit.readthedocs.org)
tsv2githubmd|print a TSV as a GitHub flavored markdown table|cat foo.tsv \|tsv2githubmd >> README.md|
tsv2redis|get redis hashes from each record of a TSV|cat foo.tsv \| tsv2redis && echo "hgetall 1" |[redis-server](http://redis.io/),[redis-tools](http://redis.io/),GNU moreutils,tawk,trim,mawk
joinmany_csv|join an arbitrary number of TSVs on a given (identically named) field|joinmany_csv "a b.csv 1.csv d e f" "project id" "full outer join"|[txt2pgsql.pl](https://raw.githubusercontent.com/albert-decatur/aiddata-utils/master/etl/txt2pgsql.pl),[postgreSQL](http://www.postgresql.org/)
joinmany_csv|join an arbitrary number of CSVs on a given (identically named) field. Note that this cannot use OUTER or RIGHT joins b/c it relies on SQLite|joinmany_csv "/tmp/a /tmp/b /tmp/c /tmp/d /tmp/e /tmp/f" project_id inner tabs|[csv2sqlite.py](https://github.com/rgrp/csv2sqlite),[SQLite3](https://sqlite.org/)
joinmany_psql|join an arbitrary number of postgres tables on a given (identically named) field|joinmany_psql "a b c d e f" project_id "full outer join" db_name| [postgreSQL](http://www.postgresql.org/)
psql_listcols|for a PostgreSQL DB, print a TSV of all table names and their corresponding field names|psql_listcols my_db|[parallel](http://www.gnu.org/software/parallel/),[mawk](http://invisible-island.net/mawk/)
samplekh|get a percent of random records but keep your header line!|cat foo.tsv \| tawk '{print $4,$5}' \| samplekh 3|bit.ly's [data_hacks](https://github.com/bitly/data_hacks)
sortkh|sort a TSV using UNIX sort options, keeping header in place|cat foo.tsv \| sortkh "-k2 -n"
sortfreq|print counts of unique values descending|cat foo.tsv \| tawk '{ print $4 }' \| sortfreq|
col_sort|use UNIX sort flags (eg -n or -d) to reorder TSV fields|col_sort -n foo.tsv \| sponge foo.tsv|[mawk](http://invisible-island.net/mawk/),[csvkit](https://csvkit.readthedocs.org),table2tsv
col_extra|print records that have content beyond expected number of fields for delimited text|cat foo.tsv \| col_extra 19|[mawk](http://invisible-island.net/mawk/)
col_swap|switch the position of two columns in delimited text|cat foo.tsv \| col_swap 3 4 \| sponge foo.tsv|[mawk](http://invisible-island.net/mawk/)
funky_chars|return the count for each unique non-alpha non-digit character in the input|cat foo.tsv \| tawk '{ print $4 }' \| funky_chars|
trim|remove leading and trailing whitespace|cat foo \| trim|
round|round numeric field to the nearest n digits|cat foo \| round 2|
sumawk|sum a single numeric field|cat foo.tsv \| tawk '{ print $2 }' \| sumawk|
uniqvals|given a TSV, return a TSV with the frequency of all unique values shown for each field|cat foo.tsv \| uniqvals \| csvlook -t \| vim - |[mawk](http://invisible-island.net/mawk/)
unique|given a single column, return the first appearance of each unique value|cat foo.tsv \| c 1 \| unique |[mawk](http://invisible-island.net/mawk/)
mkid|given a TSV, returns input with an integer ID field at the front|cat foo.tsv \| mkid
tawk|make awk take in TSV and output TSV|cat foo.tsv \| tawk '{ print $4,$5 }'|[mawk](http://invisible-island.net/mawk/)
pawk|make awk take in pipe separated and output pipe separated|cat foo.txt \| pawk '{ print $4,$5 }'|[mawk](http://invisible-island.net/mawk/)
cawk|make awk take in CSV and output CSV. NB: you usually want to use csvkit's csvcut for CSV.  delimiter collision is the norm|cat foo.csv \| cawk '{ print $4,$5 }'|[mawk](http://invisible-island.net/mawk/)
theader|print numbered TSV header|cat foo.tsv \| theader|
pheader|print numbered pipe delimited txt header|cat foo.txt \| pheader|
cheader|print numbered CSV header|cat foo.csv \| cheader|
awkcols|format a sequence of numbers as awk columns|cols=$(seq 15 1560 \| awkcols ); cat foo.tsv \| tawk "{ print $cols}" |
find_ext|find all files under current directory with a given extension|find_ext csv|
url_encode|URL encode text|url_encode 'A&P'|[URI::Escape](http://search.cpan.org/dist/URI/URI/Escape.pm)
url_decode|decode URL encoded text|url_decode 'A%26P'|[URI::Escape](http://search.cpan.org/dist/URI/URI/Escape.pm)
html_encode|HTML encode text|echo '&' \| html_encode|[HTML::Entities](http://search.cpan.org/dist/HTML-Parser/lib/HTML/Entities.pm)
html_decode|decode HTML encoded text|echo '&amp;' \| html_decode|[HTML::Entities](http://search.cpan.org/dist/HTML-Parser/lib/HTML/Entities.pm)
libretsv|force LibreOffice to open TSV as a table|libretsv foo.tsv|[LibreOffice](http://www.libreoffice.org/)
parallel|make parallel behave like GNU parallel every time|cat foo \| parallel 'echo {}'|[parallel](http://www.gnu.org/software/parallel/)
netpiglets|show processes using ports - like nethogs but smaller!|netpiglets \| xargs -I '{}' pkill {}|
c|quick cut for TSV fields|cat foo.tsv \| c 8,9
k|quick open KeePass on commandline, hard codes filepath|k|kpcli
s|quick screen lock|s|[slock](http://tools.suckless.org/slock/)
p|quick git add, commit, push|p|expects push over SSH
sr|quick open text web browser, uses surfraw elvi, otherwise assumes search with duckduckgo.com|sr george washington|surfraw
v|quick open graphical web browser vimb. assumes duckduckgo.com if not given a website|v george washinton|vimb, surfraw

* ~/.zshrc uses [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh).  
* add a file called ~/.i3/foo.png to get a fullscreen i3wm background using feh, if you change ~/.i3/config
  * existing png under ~/.i3 from [radical cartography](http://radicalcartography.net/)
* to use surfraw's "sr" alias with this ~/.zshrc you will need to 

```bash
sudo rm /usr/bin/sr
```
