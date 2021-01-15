#!/bin/bash
## created on 2015-07-17

#### Split a pdf into chapters


infile="$1"             ## input pdf
prefix="${infile%.*}"   ## oupput prefix

[[ ! -f "$infile" ]] && echo "Not a file" && exit 2

metadata="$(pdftk "$infile" dump_data_utf8)"

numberofpages=$(echo "$metadata" | grep -i "^numberofpages" | cut -f2 -d' ')

outlist="$(
paste <(echo "$metadata" | grep "^BookmarkLevel" | sed 's/BookmarkLevel: //') \
      <(echo "$metadata" | grep "^BookmarkPageNumber" | sed 's/BookmarkPageNumber: //') \
      <(echo "$metadata" | grep "^BookmarkTitle" | sed 's/BookmarkTitle: //')
      )"

levels="$(echo "$metadata" | grep "^BookmarkLevel" | sed 's/BookmarkLevel: //' | sort -u | tr '\n' ' ' )"


## Show documn outline

#printf "Level\tPage\tTitle\n"
#echo "$outlist"

echo "$outlist" | while read line; do
    level="$(echo "$line" | cut -f1)"
    page="$(echo "$line" | cut -f2)"
    title="$(echo "$line" | cut -f3-)"
    lsp="$(printf '%*s' $((4 * level - 4)) | tr ' ' '-')"

    printf "l:%2s   p:%4s   %s %s \n" "$level" "$page" "$lsp"  "$title"
done

echo
echo "Pages: $numberofpages"
read -p "Choose level to split [ $levels]: "  uservar


splitlist="$(echo "$outlist" | grep "^${uservar}")"

echo 
echo "Check splits"
echo
echo "$splitlist"


breaks=( $(echo "$splitlist" | cut -f2) )

## add first page if needed
[[ "${breaks[1]}" -ne "1" ]] && breaks=( 1 "${breaks[@]}" )
## add end
breaks=( "${breaks[@]}" "end" )

for ((i=0; i < ${#breaks[@]} - 1; ++i)); do
    a=${breaks[i]}   # start page
    b=${breaks[i+1]} # end page
    [ "$b" = "end" ] || b=$[b-1]
    [ "$b" = 0     ] && continue
    title="$(echo "$splitlist" | grep -P "\t${a}" | cut -f3-)"
    printf "%s_%f %f %s"  "$prefix" "$a" "$b"_"$title"   
#pdftk "$infile" cat $a-$b output "${outputprefix}_$a-$b.pdf"
done



exit



startp=1
echo "$splitlist" | while read line; do
    
    page="$(echo "$line" | cut -f2)"
    title="$(echo "$line" | cut -f3-)"

    echo "$startp" "$page"


done





exit

#pdftk "$infile" dump_data | grep -B1 "BookmarkLevel: 1" | grep "BookmarkTitle: " | cut -f2 -d':' | sed 's/^ //g'

exit

for ((i=0; i < ${#pagenumbers[@]} - 1; ++i)); do
  a=${pagenumbers[i]}   # start page
  b=${pagenumbers[i+1]} # end page
  [ "$b" = "end" ] || b=$[b-1]
  pdftk "$infile" cat $a-$b output "${outputprefix}_$a-$b.pdf"
done






exit 0
