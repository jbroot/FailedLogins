#!/bin/bash
#Jarren Briscoe
#Counts and sorts all failed logins from a given file
#Outputs into a website-friendly format

#test input
if [ $# -eq 0 ]
then
        echo "Usage: No file specified"
        exit 1
fi
file=$1
if [ ! -e $file ]
then
        echo "Usage: No such file exists"
        exit 1
fi

#extract usernames
#sort alphabetically 
#count unique values
#sort by unique count, then alphabetically
#replace "invalid" with HTML's <UNKNOWN>
#place commas in numbers
#add HTML break at end of lines for all of the body
body=$(sed -n 's/.*Failed password for \([a-z0-9A-Z_]*\) .*/\1/p' <$file |
	sort | 
	uniq -c | 
	sort -k1,1nr -k2,2 | 
	sed 's/[Ii]nvalid$/\&lt;UNKNOWN\&gt;/' |
	while read count userID; do
		printf "%'d %s\n" "$count" "$userID"
	done |
	sed 's#$#<br />#'
)

header="Failed Login Attempts Report as of $(date)"

output="<html>
<body><h1>$header</h1>
$body</body> </html>"

printf "%s" "$output"
