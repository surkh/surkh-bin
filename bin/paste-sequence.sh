array=("${(@f)$(pbpaste)}")
total=${#array}
for i in {1..$total}; do
  completed=$(printf "%0.s#" $(seq 1 $i))
  remaining=$(printf "%0.s-" $(seq 1 $(($total-$i))))
  echo "$completed$remaining ${array[i]}"
  echo "${array[i]}" | pbcopy
  read
done
