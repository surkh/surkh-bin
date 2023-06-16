array=("${(@f)$(pbpaste)}")
for i in {1..$#array}; do
  echo "$i/${#array}: ${array[i]}"
  echo "${array[i]}" | pbcopy
  read
done
