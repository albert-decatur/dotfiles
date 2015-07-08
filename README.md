dotfiles
========

Bash functions for data science.

alias or function|purpose|example|prerequisite
---|---|---|---
latest|print the name of the most recently modified file in the current directory|latest|
listold|list the oldest files over *n* MB in current directory|listold 100|[parallel](http://www.gnu.org/software/parallel/),[mawk](http://invisible-island.net/mawk/)
clipboard|pipe text to clipboard|cat foo \| clipboard|[xclip](http://sourceforge.net/projects/xclip/)
pdf_subset|take a page range from a PDF|pdf_subset in.pdf 23-41 out.pdf|[pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)
samplekh|get a percent of random records but keep your header line!|cat foo.tsv \| tawk '{print $4,$5}' \| samplekh 3|bit.ly's [data_hacks](https://github.com/bitly/data_hacks)
sortkh|sort a TSV using UNIX sort options, keeping header in place|cat foo.tsv \| sortkh "-k2 -n"
plotbars|use ggplot to plot fields from a TSV|cat foo.tsv \| tawk '{print $2}' \| sortfreq \| sortkh "-k2 n" \| plotbars year count "title" 20 \| feh - |ggplot2,[Rio](https://github.com/jeroenjanssens/data-science-at-the-command-line)
tsv2githubmd|print a TSV as a GitHub flavored markdown table|cat foo.tsv \|tsv2githubmd >> README.md|
tsv2redis|get redis hashes from each record of a TSV|cat foo.tsv \| tsv2redis && echo "hgetall 1" \| redis-cli --pipe|redis-server,redis-tools,moreutils,tawk,trim,mawk
psql_listcols|for a PostgreSQL DB, print a TSV of all table names and their corresponding field names|psql_listcols my_db|[parallel](http://www.gnu.org/software/parallel/),[mawk](http://invisible-island.net/mawk/)
ngrams|get ngrams of length *n* from a column, treating records as documents| ngrams <( cat foo.txt \| pawk '{print $2}') 3 |
joinmany_tsv|join an arbitrary number of TSVs on a given (identically named) field|joinmany_tsv "a b c d e f" project_id "full outer join" db_name|[txt2pgsql.pl](https://raw.githubusercontent.com/albert-decatur/aiddata-utils/master/etl/txt2pgsql.pl),postgreSQL
joinmany_csv|join an arbitrary number of CSVs on a given (identically named) field. Note that this cannot use OUTER or RIGHT joins b/c it relies on SQLite|joinmany_csv "/tmp/a /tmp/b /tmp/c /tmp/d /tmp/e /tmp/f" project_id inner tabs|[csv2sqlite.py](https://github.com/rgrp/csv2sqlite),SQLite3
joinmany_psql|join an arbitrary number of postgres tables on a given (identically named) field|joinmany_psql "a b c d e f" project_id "full outer join" db_name| postgreSQL
tawk|make awk take in TSV and output TSV|cat foo.tsv \| tawk '{ print $4,$5 }'|[mawk](http://invisible-island.net/mawk/)
pawk|make awk take in pipe separated and output pipe separated|cat foo.txt \| pawk '{ print $4,$5 }'|[mawk](http://invisible-island.net/mawk/)
cawk|make awk take in CSV and output CSV. NB: you usually want to use csvkit's csvcut for CSV.  delimiter collision is the norm|cat foo.csv \| cawk '{ print $4,$5 }'|[mawk](http://invisible-island.net/mawk/)
theader|print numbered TSV header|cat foo.tsv \| theader|
pheader|print numbered pipe delimited txt header|cat foo.txt \| pheader|
cheader|print numbered CSV header|cat foo.csv \| cheader|
table2tsv|convert any Gnumeric compatible table to TSV|cat foo.csv \| table2tsv|[Gnumeric](http://www.gnumeric.org/)
table2csv|convert any CSVKit compatible table to CSV|cat foo.tsv \| table2csv|[csvkit](https://csvkit.readthedocs.org)
sortfreq|print counts of unique values descending|cat foo.tsv \| tawk '{ print $4 }' \| sortfreq|
funky_chars|return the count for each unique non-alpha non-digit character in the input|cat foo.tsv \| tawk '{ print $4 }' \| funky_chars|
trim|remove leading and trailing whitespace|cat foo \| trim|
round|round numeric field to the nearest n digits|cat foo \| round 2|
awksum|sum a single numeric field|cat foo.tsv \| tawk '{ print $2 }' \| awksum|
col_extra|print records that have content beyond expected number of fields for delimited text|col_extra foo.txt 12 "\|"|[parallel](http://www.gnu.org/software/parallel/),[mawk](http://invisible-island.net/mawk/)
col_swap|switch the position of two columns in delimited text|cat foo.tsv \| col_swap 3 4 \| sponge foo.tsv|[mawk](http://invisible-island.net/mawk/)
col_sort|use UNIX sort flags (eg -n or -d) to reorder TSV fields|col_sort -n foo.tsv \| sponge foo.tsv|[mawk](http://invisible-island.net/mawk/),[csvkit](https://csvkit.readthedocs.org),table2tsv
awkcols|format a sequence of numbers as awk columns|cols=$(seq 15 1560 \| awkcols ); cat foo.tsv \| tawk "{ print $awkcols}" |
find_ext|find all files under current directory with a given extension|find_ext csv|
url_encode|URL encode text|url_encode 'A&P'|[URI::Escape](http://search.cpan.org/dist/URI/URI/Escape.pm)
url_decode|decode URL encoded text|url_decode 'A%26P'|[URI::Escape](http://search.cpan.org/dist/URI/URI/Escape.pm)
html_encode|HTML encode text|echo '&' \| html_encode|[HTML::Entities](http://search.cpan.org/dist/HTML-Parser/lib/HTML/Entities.pm)
html_decode|decode HTML encoded text|echo '&amp;' \| html_decode|[HTML::Entities](http://search.cpan.org/dist/HTML-Parser/lib/HTML/Entities.pm)
libretsv|force LibreOffice to open TSV as a table|libretsv foo.tsv|[LibreOffice](http://www.libreoffice.org/)
dumbplot|use GNUplot to graph one or two numeric fields in the terminal. removes header if found. assumes should graph points but can graphs lines| cat foo.tsv \| cut -f3,4 \| dumbplot OR cat foo.tsv \| cut -f4 \| dumbplot lines |[gnuplot](http://www.gnuplot.info/download.html)
uniqvals|given a TSV, return a TSV with the frequency of all unique values shown for each field|uniqvals foo.tsv \| csvlook -t \| vim - |[mawk](http://invisible-island.net/mawk/)
mkid|given a TSV, retursn the TSV with an integer ID field at the front|cat foo.tsv \| mkid
parallel|make parallel behave like GNU parallel every time|cat foo \| parallel 'echo {}'|[parallel](http://www.gnu.org/software/parallel/)
