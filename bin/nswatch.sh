if [[ $# -eq 0 ]]; then
  NSS=$(kubens -c)
else
  NSS=""
  while [[ $# -gt 0 ]]; do
    NSS="${NSS} $1"
    shift
  done
fi

echo $NSS

watch -- "for NS in $NSS; do echo \$NS; kubectl get pod --namespace \$NS --sort-by=metadata.creationTimestamp ; echo ; done"
