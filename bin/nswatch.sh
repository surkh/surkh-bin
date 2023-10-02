NSS=""
while [[ $# -gt 0 ]]; do
  NS=$1
  NSS="${NSS}${NS} "
  shift
done

watch -- "
kctx -c
echo =================

current_ns=\$(kubens -c)
NSLIST=$NSS;

# Check if $current_ns is NOT in $NSS
if ! echo \"\$NSLIST\" | grep -qw \"\$current_ns\"; then
  NSLIST=\" \$NSLIST \$current_ns \"
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
