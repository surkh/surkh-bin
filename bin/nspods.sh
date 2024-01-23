#!/bin/zsh

# Collect namespaces from arguments into an array
declare -a NSS=("$@")

echo Context: "$(kubectl-ctx -c)"
echo

current_ns=$(kubens -c)

# Create a copy of the NSS array
declare -a NSLIST=(${NSS[@]})

# Check if NSLIST is empty or if current_ns is NOT in NSLIST array
if [[ ${#NSLIST[@]} -eq 0 ]] || [[ ! " ${NSLIST[*]} " =~ " $current_ns " ]]; then
    NSLIST=("$current_ns" "${NSLIST[@]}")
fi

for NS in "${NSLIST[@]}"; do
    if [[ "$NS" == "$current_ns" ]]; then
        echo "==> $NS <=="
    else
        echo "    $NS    "
    fi
    kubectl get pod --namespace $NS --sort-by=metadata.creationTimestamp -o wide
    echo
done
