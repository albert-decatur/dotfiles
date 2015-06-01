dotfiles
========

My ~/.bashrc and others.

.bashrc functions and aliases are as follows.

alias or function|purpose|example|prerequisite
---|---|---|---
latest|print the name of the most recently modified file in the current directory|latest|
listold|list the oldest files over *n* MB in current directory|listold 100|[parallel](http://www.gnu.org/software/parallel/),[mawk](http://invisible-island.net/mawk/)
clipboard|pipe text to clipboard|cat foo \| clipboard|[xclip](http://sourceforge.net/projects/xclip/)
pdf_subset|take a page range from a PDF|pdf_subset in.pdf 23-41 out.pdf|[pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)
tsv2githubmd|cat foo.tsv \| tsv2githubmd |print a TSV as a GitHub flavored markdown table|
psql_listcols|for a PostgreSQL DB, print a TSV of all table names and their corresponding field names|psql_listcols my_db|[parallel](http://www.gnu.org/software/parallel/),[mawk](http://invisible-island.net/mawk/)
ngrams|get ngrams from a column, treating records as documents| ngrams <( cat foo.txt \| pawk '{print $2}') 3 |
join_multi_w_singleField|join an arbitrary number of postgres tables on a given (identically named) field|join_multi_w_singleField "a b c d e f" project_id "full outer join" db_name|postgreSQL
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
dumbplot|use GNUplot to graph a single numeric field|cat foo.tsv \| tawk '{ print $4 }' \| sed '1d' \| dumbplot |[gnuplot](http://www.gnuplot.info/download.html)
uniqvals|given a TSV, return a TSV with the frequency of all unique values shown for each field|uniqvals foo.tsv \| csvlook -t \| less |[mawk](http://invisible-island.net/mawk/)
killname|kill a process or processes by name - can be dangerous!|killname chrome|
parallel|cat foo \| parallel 'echo {}'|make parallel behave like GNU parallel every time|[parallel](http://www.gnu.org/software/parallel/)
