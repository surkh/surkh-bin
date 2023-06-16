#!/bin/zsh
array=("${(@f)$(pbpaste)}")
total=${#array}
for i in {1..$total}; do
  completed=$(repeat $i printf "-")
  remaining=$(repeat $(($total-$i)) printf "#")
  echo "$completed$remaining ${array[i]}"
  echo "${array[i]}" | pbcopy
  read
done
