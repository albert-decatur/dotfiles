dotfiles
========

My ~/.bashrc and others.
.bashrc functions and aliases are as follows.

alias or function|purpose
---|---
parallel|make parallel behave like GNU parallel every time
tawk|take in TSV and output TSV
pawk|take in pipe separated and output pipe separated
theader|print numbered TSV header
cheader|print numbered CSV header
sortfreq|print counts of unique values descending
clipboard|pipe text to clipboard
awkcols|format a sequence of numbers as awk columns
trim|remove leading and trailing whitespace
table2tsv|convert any Gnumeric compatible table to TSV
table2csv|convert any CSVKit compatible table to CSV
listold|list the oldest files over 1GB in current directory
psql_listcols|for a PostgreSQL DB, print a TSV of all table names and their corresponding field names
diff_prep|prepare a set of records from a table for vimdiff or wdiff by transposing their delimiters with newline
cols_extra|print records that have content beyond expected number of fields for delimited text
cols_swap|switch the position of two columns in delimited text
find_ext|find all files under current directory with a given extension
awksum|sum a single numeric field
latest|print the name of the most recently modified file in the current directory
detect_chars|print character encoding of each unique character in input
libretsv|force LibreOffice to open TSV as a table
join_multi_w_singleField|print the SQL to join an arbitrary number of tables on a given (identically named) field
col_sort|use UNIX sort flags (eg -n or -d) to reorder TSV fields
dumbplot|use GNUplot to graph a single numeric field
tsv2githubmd|print a TSV as a GitHub flavored markdown table
