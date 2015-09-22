# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:$HOME/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


#########

# set vim keybindings
bindkey -v
# get reverse history search
bindkey '^R' history-incremental-search-backward
# set vim as default editor
export EDITOR=vim
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
# GNU parallel why you no use GNU by default?
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
# more generic than csvformat from csvkit but slower, eg works on xlsx
# requires gnumeric's ssconvert
function table2tsv { 
	ssconvert --export-type Gnumeric_stf:stf_assistant -O 'separator="	"' fd://0 fd://1 2>/dev/null
}
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
# user args: 1) input txt to check, 2) number of columns the file should have
function col_extra { 
	intsv=$(cat)
	echo "$intsv" | tawk "{if(NF > $1)print \$0}"
}
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
	# for the benefit of joinmany_tsv, strip text after a period - hope table names don't have periods!
	tables=$( echo "${tables[@]}" | tr ' ' '\n' | sed 's:[.][^.]*$::g' )
	tables=($tables)
	# get the number of tables to join
	num_elements=$( expr ${#tables[@]} - 1 )
	for n in $(seq 0 $num_elements)
	do 
		# if the number of tables is reached, do nothing
		if [[ $n -eq $num_elements ]]; then 
			false
		# if the number of tables is not reached, join the current table to the next table using the user specified join type
		elif [[ $n -eq 0 ]]; then 
			echo "\"${tables[$n]}\" $3 \"${tables[$( expr $n + 1 )]}\" USING (\"$2\")"
			unset tables[$n]
		else 
			echo "$3 \"${tables[$( expr $n + 1 )]}\" USING (\"$2\")"
			unset tables[$n]
		fi
	done |\
	tr '\n' ' ' |\
	# surround the join SQL with SQL for copying to stdout as tsv
	sed "s:^:SELECT * FROM :g" |\
	sed "s:^:COPY (:g;s:$:) TO STDOUT WITH DELIMITER E'\t' CSV HEADER:g" |\
 	psql $4
}
# join arbitrary number of TSVs or CSVs
# first imports to psql with txt2pgsql.pl, then uses function joinmany_psql
# NB: user must have postgre permissions to createdb and dropdb
# TODO: double quotes get quoted - just fix
# NB: must be executed in same directory as input files - ouch
# user args: 1) double quoted list of TSVs / CSVs, 2) name of field to join on, 3) 
# example use: joinmany_csv "foo.csv bar.csv 1.csv" "example field" "full outer join" csv
function joinmany_csv {
	# define list of TSVs
	tsvs=( $1 )
	# create a tmp pgsql db
	tmpdb=$(mktemp)
	createdb $tmpdb
	# load up your list of TSVs into the tmpdb
	# if there is a 4th user arg, check for "csv" or "tsv"
	# if not, assume TSV
	if [[ $# -ge 3 ]]; then
		if [[ "$4" == "tsv" ]]; then
			d=","
		else
			# if not csv, assume tsv
			d="\t"
		fi
	else
		d=","
	fi
	for i in "${tsvs[@]}"
	do
		txt2pgsql.pl -i $i -d "$d" -t "TEXT" -p $tmpdb | sh &>/dev/null
	done
	# now run joinmany_psql!
	joinmany_psql "$1" "$2" "$3" $tmpdb
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
function uniqvals { 
		intsv=$(cat)
		header=$(echo "$intsv" | head -n 1)
		nfields=$( echo "$header" | tr '\t' '\n' | wc -l )
		for field in $(seq 1 $nfields)
		do 
			echo "$intsv" | sed '1d' | mawk -F'\t' "{print \$$field}" | sort | uniq -c | sort -k1 -rn > /tmp/${field}
		done
		echo "$header"
		paste -d'\t' $(seq 1 $nfields | sed 's:^:/tmp/:g')
	}
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
	raw=$( cat | rawgrams )
	# for every integer "n" between 1 and the user specified number of terms for the ngram,
	# remove the first "n-1" terms and write to file ( note that writing to static filenames prevents using this in parallel ).
	# then these files are pasted together.
	# note that no terms are ignored for the first pass because the first term must be included!
	paste $( 
		for n in $( seq 1 $1 )
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
	awk -v gramlength=$1 '{ if ( NF == gramlength ) print $0 }'
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
# hope no field is named "id"!
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
# convert every record of a TSV into a redis hash using the first field as the hash name field
# NB: may want to clean up quotes, definitely want an ID field
# example use: cat foo.tsv | tsv2redis && echo "hgetall 1" | redis-cli --pipe
function tsv2redis { 
	in=$(cat)
	# get just the header
	header=$(echo "$in" | head -n 1 )
	# prepping for awk, get the name of every field followed by the field number
	for_awk=$( 
		echo "$header" |\
	 	sed 's:\t:\n:g' |\
		sed 's:^\|$:":g' |\
		nl |\
		trim |\
		sed 's:^:\$:g' |\
		tawk '{print $2,$1}' |\
		tr '\t' ',' |\
		tr '\n' ',' |\
		sed 's:,$::g' |\
		sed 's:"\+:":g'
	)
	# prints the field names, then their contents, for each record, eg "FirstName Janez LastName Novak"
	toCountBytes=$( 
		echo "$in" |\
		sed '1d' |\
		tawk "{print $for_awk}" 
	)
	# write Redis RESP bulk string
	echo "$toCountBytes" |\
	# for each element of the hash, count the number of bytes and prepend a $.
	# except at the beginning we must specify number of elements and that we are defining a hash with HMSET 
	# NB: LANG=C is needed for awk to use bytes for length() instead of characters
	# RESP bulk strings take the form "*2\r\n$3\r\nfoo\r\n$3\r\nbar\r\n"
	LANG=C tawk '{OFS="\n"; print "*"NF,"$5","HMSET"; for(i=2;i<=NF;i++)print "$"length($i),$i}' |\
	# append carriage return to end line
	# NB: sed using forward slash delimiters allow for special whitespace characters!
	sed 's/$/\r/' |\
	# actually pipe to redis server - assumes default port
	redis-cli --pipe
}
# sort TSV fields using UNIX sort options in double quotes - keeps header!
# example sorting by field 2: cat foo.tsv | sortkh "-k2 -rn"
function sortkh { 
	in=$(cat)
	header=$(echo "$in" | head -n 1)
	echo "$in" |\
	sed '1d' |\
	# sort with user options in double quotes
	sort $1 -t'	'|\
	sed "1 i$header"
}
# use [Rio](https://github.com/jeroenjanssens/data-science-at-the-command-line) to make a bar chart of TSV from STDIN - for example output of sortfreq
# NB: prints PNG to STDOUT so may want to pipe to "feh -" or redirect to file
# example use: cat foo.tsv | tawk '{print $2}' | sortfreq | bargraph year count "title" 20 | feh -ZF -
# note that sortkh is used to get the lowest value on the top of the graph, which will flip when ggplot's coord_flip() is used
# note that the only needed user args are x and y - you can ignore title, title size, and dimensions for faster graphing, ideal for piping to "feh -"
# high res example use: cat foo.tsv | tawk '{print $2}' | sortfreq | sortkh "-k1 -n" | bargraph year count "title" 20 6 9 > foo.png
function plotbars { 
	x=$1
	y=$2
	# get vars for axis titles - keeps original text
	x_axis_title=$1
	y_axis_title=$2
	# variable names lose spaces, any quotes must be escaped
	x=$(echo "$x" | sed 's: :.:g;s:"::g')
	y=$(echo "$y" | sed 's: :.:g;s:"::g')
	titleText=$3
	titleSize=$4
	height=$5
	width=$6
	if [[ "$#" -lt 5 ]]; then 
		# if only first user args are used, then 
		# sets no res/dimensions - smaller res but much faster
		Rio -d'\t' -ge "df\$$x <- factor(df\$$x, levels=unique(df\$$x));ggplot(df,aes(y=$y,x=$x)) + geom_bar(stat=\"identity\") + coord_flip() + labs(title=\"$titleText\",x=\"$x_axis_title\",y=\"$y_axis_title\") + theme(plot.title=element_text(size=$titleSize))"
	else
		# sets user specified height and width, dpi = 600
		# get tmp png name
		tmppng=$(mktemp -u --suffix .png)
		Rio -d'\t' -ge "png(\"$tmppng\",units=\"in\",height=$5,width=$6,res=600); df\$$x <- factor(df\$$x, levels=unique(df\$$x));ggplot(df,aes(y=$y,x=$x)) + geom_bar(stat=\"identity\") + coord_flip() + labs(title=\"$titleText\",x=\"$x_axis_title\",y=\"$y_axis_title\") + theme(plot.title=element_text(size=$titleSize)); dev.off()" 1>/dev/null
		cat $tmppng
	fi
}
# quick cut
# example to print 8th and 9th fields of a TSV: cat foo.tsv | c 8,9
function c {
	cut -f$1
}
# quick access to keepass2 via cli
function k {
	kpcli --kdb ~/Database.kdbx
}
# quick screen locking
function s {
	# turn screen off
	xset dpms force off
	# lock screen
	slock
}
# quick generic git add, commit (send to editor), and push
function p {
	git add . && git add -u && git commit && git push origin master
}
# quick duckduckgo search on surfraw
# unless an elvis is specified
# NB: you should remove /usr/bin/sr to use this
function sr {
        elvi=$(surfraw -elvi | grep -v "GLOBAL ELVI"|grep -oE "^[^--]*")
        if [[ -z $(echo "$elvi" | grep -E "\b$1\b") ]]; then
            surfraw duckduckgo "$@"
        else
            surfraw "$@"
        fi
}
# quick access to graphical web browser vimb
# will visit ^.*:// directly but all others to duckduckgo
function v {
        if [[ -n $(echo "$@" | grep -E "^.*://" ) ]]; then
            /usr/local/bin/vimb "$@"
        else
	    surfraw -browser=/usr/local/bin/vimb duckduckgo "$@"
        fi
}
