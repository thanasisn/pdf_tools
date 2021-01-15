#!/bin/bash
## created on 2015-07-17

#### Split a pdf into chapters


infile="$1"             ## input pdf
prefix="${infile%.*}"   ## oupput prefix

[[ ! -f "$infile" ]] && echo "Not a file" && exit 2

metadata="$(pdftk "$infile" dump_data_utf8)"

numberofpages=$(echo "$metadata" | grep -i "^numberofpages" | cut -f2 -d' ')


echo "$metadata"
















## display levels
## choose level to slit
## include split title

echo
echo "Pages: $numberofpages"


exit
pagenumbers=( $(pdftk "$infile" dump_data | \
                grep '^BookmarkPageNumber: ' | cut -f2 -d' ' | uniq)
              end )

echo $pagenumbers

pagenumbers=( 1 $(pdftk "$infile" dump_data | grep -A1 "BookmarkLevel: 1" | grep "BookmarkPageNumber:" | cut -f2 -d' ' | uniq)  end )

echo $pagenumbers

#pdftk "$infile" dump_data | grep -B1 "BookmarkLevel: 1" | grep "BookmarkTitle: " | cut -f2 -d':' | sed 's/^ //g'

exit

for ((i=0; i < ${#pagenumbers[@]} - 1; ++i)); do
  a=${pagenumbers[i]}   # start page
  b=${pagenumbers[i+1]} # end page
  [ "$b" = "end" ] || b=$[b-1]
  pdftk "$infile" cat $a-$b output "${outputprefix}_$a-$b.pdf"
done






exit 0
