dotfiles
========

My ~/.bashrc and others.

.bashrc functions and aliases are as follows.

alias or function|purpose|prerequisite
---|---|---
latest|print the name of the most recently modified file in the current directory|
listold|list the oldest files over 1GB in current directory|[parallel](http://www.gnu.org/software/parallel/),[mawk](http://invisible-island.net/mawk/)
clipboard|pipe text to clipboard|[xclip](http://sourceforge.net/projects/xclip/)
pdf_subset|take a page range from a PDF|[pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)
tsv2githubmd|print a TSV as a GitHub flavored markdown table|
parallel|make parallel behave like GNU parallel every time|[parallel](http://www.gnu.org/software/parallel/)
tawk|make awk take in TSV and output TSV|[mawk](http://invisible-island.net/mawk/)
pawk|make awk take in pipe separated and output pipe separated|[mawk](http://invisible-island.net/mawk/)
theader|print numbered TSV header|
cheader|print numbered CSV header|
table2tsv|convert any Gnumeric compatible table to TSV|[Gnumeric](http://www.gnumeric.org/)
table2csv|convert any CSVKit compatible table to CSV|[csvkit](https://csvkit.readthedocs.org)
sortfreq|print counts of unique values descending|
funky_chars|return the count for each unique non-alpha non-digit character in the input|
trim|remove leading and trailing whitespace|
round|round numeric field to the nearest n digits|
awksum|sum a single numeric field|
col_extra|print records that have content beyond expected number of fields for delimited text|[parallel](http://www.gnu.org/software/parallel/),[mawk](http://invisible-island.net/mawk/)
col_swap|switch the position of two columns in delimited text|[mawk](http://invisible-island.net/mawk/)
col_sort|use UNIX sort flags (eg -n or -d) to reorder TSV fields|
awkcols|format a sequence of numbers as awk columns|
psql_listcols|for a PostgreSQL DB, print a TSV of all table names and their corresponding field names|[parallel](http://www.gnu.org/software/parallel/),[mawk](http://invisible-island.net/mawk/)
find_ext|find all files under current directory with a given extension|
url_encode|URL encode text|[URI::Escape](http://search.cpan.org/dist/URI/URI/Escape.pm)
url_unencode|decode URL encoded text|[URI::Escape](http://search.cpan.org/dist/URI/URI/Escape.pm)
html_encode|HTML encode text|[HTML::Entities](http://search.cpan.org/dist/HTML-Parser/lib/HTML/Entities.pm)
html_decode|decode HTML encoded text|[HTML::Entities](http://search.cpan.org/dist/HTML-Parser/lib/HTML/Entities.pm)
libretsv|force LibreOffice to open TSV as a table|[LibreOffice](http://www.libreoffice.org/)
dumbplot|use GNUplot to graph a single numeric field|[gnuplot](http://www.gnuplot.info/download.html)
join_multi_w_singleField|print the SQL to join an arbitrary number of tables on a given (identically named) field|[csvkit](https://csvkit.readthedocs.org)
