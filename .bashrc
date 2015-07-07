# set vim as default editor
export EDITOR=vim
# vim style keybindings for bash
set -o vi

# save bash history across terminal windows, especially good for GNU screen, tmux, etc
# credit to http://unix.stackexchange.com/users/348/user348 from http://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups  
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# print name of most recently modified file in dir
function latest { ls -c $1 | sed -n '1p' | sed 's:^:\":g;s:$:\":g'; }
export latest
# list oldest files over *n* MB under current dir
# note that MB count must be integer
function listold { find . -size +$1M -printf "%p\t%k\t%TY-%Tm-%Td\n" | sort -k3,3 -t'	' -n | awk -F'\t' '{print $1}'; }
export listold
# copy stdout to clipboard
# like Mac's pbcopy
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
# use mawk with pipe delimiter for input and output
alias pawk='mawk -F "|" -v OFS="|"'
# use mawk with pipe delimiter for input and output
alias cawk='mawk -F "," -v OFS=","'
# print numbered header of a TSV
alias theader="head -n 1 | tr '\t' '\n' | nl -ba | sed 's:^[ \t]\+::g;s:[ \t]\+$::g'"
# print numbered header of a CSV
alias pheader="head -n 1 | tr '|' '\n' | nl -ba | sed 's:^[ \t]\+::g;s:[ \t]\+$::g'"
# print numbered header of a CSV
alias cheader="head -n 1 | tr ',' '\n' | nl -ba | sed 's:^[ \t]\+::g;s:[ \t]\+$::g'"
# convert Gnumeric-recognized tables to TSV
# more generic than csvformat from csvkit but slower
# requires gnumeric's ssconvert
function table2tsv { ssconvert --export-type Gnumeric_stf:stf_assistant -O 'separator="	"' fd://0 fd://1; }
export -f table2tsv
# convert TSV to CSV - uses csvkit, assumes input is TSV
# also assumes max field size of no more than 1m characters
# ssconvert does not have these limit flags but it is much slower
function table2csv { csvformat -t -z 1000000 $1;}
export table2csv
# print frequency of unique entries descending
# keeps header in place
function sortfreq { 
	in=$(cat)
	header=$(echo "$in" | head -n 1)
	echo "$in" |\
	sed '1d' |\
	sort |\
	uniq -c |\
	sort -k1 -rn |\
 	sed 's:^[ \t]\+::g;s:[ \t]\+$::g;s:^\([0-9]\+\) :\1\t:g' |\
	sed "1 icount\t${header}"
}
# return the count of non alpha / non digit characters sorted descending
# this only works well with English - should replace with UTF8 friendly funky_chars
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
function url_encode { perl -MURI::Escape -e 'print uri_escape(<STDIN>); print "\n";';}
# URL unencode
function url_decode { perl -MURI::Escape -e 'print uri_unescape(<STDIN>); print "\n";';}
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
# use GNUplot to plot one or two columns of values, inspired by jeroenjanssens
# https://github.com/jeroenjanssens/data-science-at-the-command-line/blob/master/tools/dumbplot
# assumes tab separated, removes header if found, assumes plot type points unless user supplies argument
# example: cat foo.tsv | cut -f3,4 | dumbplot
# example: cat foo.tsv | cut -f3 | dumbplot lines
function dumbplot { 
	# hard coded plot size in characters - please change according to taste!
	size="110 30"
	# if user does not supply plot type, assumes points
	if [[ -z $1 ]]; then 
		plotType=points
	else 
		plotType=$1
	fi
	in=$(cat)
	if [[ -n $( echo "$in" | head -n 1 | grep -vE "[0-9.-]+" ) ]]; then 
		echo "$in" |\
		# first line appears to be a header because it has characters other than numbers, hyphens, and periods. remove it.
		sed '1d' |\
		gnuplot -e "set term dumb size $size; set datafile separator \"\t\"; plot \"-\" with $plotType"
	else 
		# keep first line - does not appear to be a header
		echo "$in" |\
		gnuplot -e "set term dumb size $size; set datafile separator \"\t\"; plot \"-\" with $plotType"
	fi
}
export dumbplot
# write SQL to join an arbitrary number of tables to each other, given that they have a field of the same name to join on
# use double quoted list for table names
# example use: joinmany_psql "1 2 3 4" example_id_field "full outer join" foo_db
function joinmany_psql { 
	field=$2
	tables=( $1 )
	# get the number of tables to join
	num_elements=$( expr ${#tables[@]} - 1 )
	for n in $(seq 0 $num_elements)
	do 
		# if the number of tables is reached, do nothing
		if [[ $n -eq $num_elements ]]; then 
			false
		# if the number of tables is not reached, join the current table to the next table using the user specified join type
		elif [[ $n -eq 0 ]]; then 
			echo "\"${tables[$n]}\" $3 \"${tables[$( expr $n + 1 )]}\" USING ($2)"
			unset tables[$n]
		else 
			echo "$3 \"${tables[$( expr $n + 1 )]}\" USING ($2)"
			unset tables[$n]
		fi
	done |\
	tr '\n' ' ' |\
	# surround the join SQL with SQL for copying to stdout as tsv
	sed "s:^:SELECT * FROM :g" |\
	sed "s:^:COPY (:g;s:$:) TO STDOUT WITH DELIMITER E'\t' CSV HEADER:g" |\
 	psql $4
}
# join arbitrary number of TSVs
# first imports to psql with txt2pgsql.pl, then uses function joinmany_psql
# user args same as joinmany_psql
# NB: user must have postgre permissions to createdb and dropdb
function joinmany_tsv {
	# define list of TSVs
	tsvs=( $1 )
	# create a tmp pgsql db
	tmpdb=$(mktemp)
	createdb $tmpdb
	# load up your list of TSVs into the tmpdb
	for i in "${tsvs[@]}"
	do
		txt2pgsql.pl -i $i -d "\t" -t "TEXT" -p $tmpdb | sh &>/dev/null
	done
	# now run joinmany_psql!
	joinmany_psql "$1" "$2" "$3" $4
	dropdb $tmpdb
}
# write SQLite to join an arbitrary number of CSVs, given that they have a field of the same name to join on
# NB: because SQLite lacks OUTER JOIN, this is not nearly as useful as joinmany_psql, though this uses CSVs directly which is convenient
# user args: 1) double quoted list of CSVs to join, with full path, 2) id field all will join on, 3) join type (just LEFT or INNER for SQLite), 4) export type - csv or tabs
# example use: join_multi_w_singleField "/tmp/1 /tmp/2 /tmp/3 /tmp/4" example_id_field left csv
function joinmany_csv { 
	field=$2
	tables=( $1 )
	# import each with rgrp's csv2sqlite.py
	# use a sqlite db under tmp
	# prefix "a_" to table names to allow for numeric table names
	tmpdb=$(mktemp --suffix .sqlite)
	# NB: csv2sqlite.py needs full path to input CSV
	for n in "${tables[@]}"
	do
		csv2sqlite.py $n $tmpdb a_$(basename $n )
	done
	# change the tables array to use the new SQLite table names from the csv2sqlite.py import
	tables=( 
		$( 
			echo "${tables[@]}" |\
			tr ' ' '\n' |\
			xargs -I '{}' basename {} |\
			sed 's:^:a_:g' 
		) 
	)
	# get the number of tables to join
	num_elements=$( expr ${#tables[@]} - 1 )
	# now print SQL to get all tables to join according to user specified join type, on user specified field
	sqlite_string=$(
		for n in $(seq 0 $num_elements)
		do 
			# if the number of tables is reached, do nothing
			if [[ $n -eq $num_elements ]]; then 
				false
			# if the number of tables is not reached, join the current table to the next table using the user specified join type
			elif [[ $n -eq 0 ]]; then 
				echo "\"${tables[$n]}\" $3 JOIN \"${tables[$( expr $n + 1 )]}\" USING ($2)"
				unset tables[$n]
			else 
				echo "$3 JOIN \"${tables[$( expr $n + 1 )]}\" USING ($2)"
				unset tables[$n]
			fi
		done |\
		tr '\n' ' ' |\
		# surround the join SQL with SQL for copying to stdout as tsv
		sed "s:^:SELECT * FROM :g;s:$:\;:g"
	)
	# make tmpsql file for commands to live
	tmpsql=$(mktemp)
	# use SQLite dialect for exporting as csv or tab, print header
	echo -e ".mode $4\n.header on\n" > $tmpsql
	echo "$sqlite_string" >> $tmpsql
	# NB: not sure why, but saving to file and then pipe works but piping directly does not!
	cat $tmpsql | sqlite3 $tmpdb
	# cleanup tmp files
	rm $tmpdb $tmpsql
}
# get a count of unique entries in every field in a TSV
function uniqvals { intsv=$1; header=$(cat $intsv | head -n 1); nfields=$( echo "$header" | tr '\t' '\n' | wc -l ); for field in $(seq 1 $nfields); do cat $intsv | sed '1d' | mawk -F'\t' "{print \$$field}" | sort | uniq -c | sort -k1 -rn > /tmp/${field}; done; echo "$header"; paste -d'\t' $(seq 1 $nfields | sed 's:^:/tmp/:g'); }
export uniqvals
# the following two functions create ngrams - length is chosen by the user
# the first - rawgrams - provides a simplified word list, with no punctuation or standalone runs of numbers, all lowercase, breaks on whitespace
# the second - ngrams - uses rawgrams to make a set of ngrams for the input doc
# ngrams respects newlines as doc breaks - meaning it is meant for columns of text where each record is considered a doc
# it also requires that user specified gram length be respected, meaning that partial ngrams will be ignored
# some quirky stuff - it considers punctuation to be the start of a new term, except for apostrophes which it ignores - this is because of english possessive
# example use to find trigrams by frequency from the second column of a TSV, ignoring header: ngrams <( cat foo.tsv | tawk '{ print $2 }' | sed '1d' ) 3 | sortfreq
function rawgrams { 
	# remove apostrophes because of english possessive
	tr -d "'" |\
	# convert punctuation to whitespace - this breaks new terms on punctuation
	tr '[:punct:]' ' ' |\
	# convert newline to colon - remember, there are no colons now that we removed punct
	tr '\n' ':' |\
	# convert colons to ' : ' - we provide the whitespace so they will be considered terms
	# this helps us split "documents" on newline
	sed 's:\:: \: :g' |\
	# convert whitespace to newline
	# this determines what is counted as a term
	tr ' ' '\n' |\
	# remove totally blank records
	grep -vE "^$" |\
	# remove records that are nothing but runs of numbers
	# notice that we keep records that may contain numbers in their terms, for example '1st'
	grep -vE "^[0-9]+$" |\
	# convert all terms to lowercase
	awk '{ print tolower($0) }'
}
function ngrams { 
	# use the rawgrams function on the first user arg to get terms
	raw=$( cat $1 | rawgrams )
	# for every integer "n" between 1 and the user specified number of terms for the ngram,
	# remove the first "n-1" terms and write to file ( note that writing to static filenames prevents using this in parallel ).
	# then these files are pasted together.
	# note that no terms are ignored for the first pass because the first term must be included!
	paste $( 
		for n in $( seq 1 $2 )
			do 
				if [[ $n > 1 ]]; then 
					d=$(($n-1))
					echo "$raw" |\
					sed "1,${d}d" > /tmp/$n
				else 
					echo "$raw" > /tmp/$n
				fi
				echo /tmp/$n
			done
	) |\
	# remove standalone colons - these were our standins for newline so we could consider newline a separator for new docs
	grep -oE "[^:]+" |\
	# remove tabs with no term next to them - this is to clean up after ngrams that were partly composed of ' : '
	sed 's:^\t::g;s:\t$::g;s:\t\+:\t:g' |\
	# enforce the user input gram term count - before this the ngrams could be shorter than user specification if the document was too short
	awk -v gramlength=$2 '{ if ( NF == gramlength ) print $0 }'
}
# use bitly's sample.py from data_hacks to get n% of records randomly from STDIN, but keep the first record!
function samplekh { 
	# save whole input
	in=$( cat )
	# grab header
	header=$( echo "$in" | head -n 1 )
	echo "$in" |\
	# remove header before sampling
	sed '1d' |\
	# use bitly's data_hacks sample.py! with user arg for prct
	sample.py $1% 2>/dev/null |\
	# slap header back on
	sed "1 i$header"
}
# function to make ID field - 1-based unique intergers, one per record
function mkid { 
	in=$(cat)
	# saves header
	header=$(echo "$in" | head -n 1)
	echo "$in" |\
	# removes header
	sed '1d' |\
	# NB: even numbers blank lines
	nl -ba |\
	# trims leading whitespace, inserts tab delimiter
	sed 's:^\s\+::g;s:^\([0-9]\+\) :\1\t:g' |\
	# adds back header
	sed "1 iid\t${header}"
}
