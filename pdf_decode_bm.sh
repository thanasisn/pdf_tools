#!/bin/bash
## created on 2019-03-10

#### A helper script to concert pdftk bookmarks to a formated text file for human editing

## no sorting is done in the pdf
## extra spaces in variables are not allowed

# BookmarkBegin
# BookmarkTitle: Solar Energy Engineering: Processes and Systems
# BookmarkLevel: 1
# BookmarkPageNumber: 4

### may sort with:    sort -u | sort -t$'\t' -k1n -k2V
### will not always work

FILE="$1"
[[ ! -f "$FILE" ]] && echo "Not file input" && echo "exit" && exit 1


paste <(grep -A3 "BookmarkBegin" "$FILE" | grep  "BookmarkPageNumber: " | grep -o "[0-9]\+")                   \
      <(grep -A3 "BookmarkBegin" "$FILE" | grep  "BookmarkLevel: " | grep -o "[0-9]\+" | while read line;do
            ff=$(printf '%*s' "$line" | tr ' ' '#' )
            echo $ff
        done)                                                                                                  \
      <(grep -A3 "BookmarkBegin" "$FILE" | grep "BookmarkTitle: " | sed 's/BookmarkTitle: //')                 |\
      col -x

exit 0
