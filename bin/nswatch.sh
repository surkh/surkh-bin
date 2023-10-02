NSS=""
while [[ $# -gt 0 ]]; do
  NS=$1
  NSS="${NSS}${NS} "
  shift
done

watch -- "
kctx -c
if [ -z \"$NSS\" ];
  then NSLIST=\$(kubens -c)
  else NSLIST=\"$NSS\";
fi;
for NS in \$NSLIST; do
  if [ \"\$NS\" == \"\$(kubens -c)\" ]; then
    echo \"==> \$NS <==\"
  else
    echo \"    \$NS    \"
  fi;
  kubectl get pod --namespace \$NS --sort-by=metadata.creationTimestamp;
  echo
done
"
