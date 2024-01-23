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
{
    echo -e "NAME\tREADY\tSTATUS\tRESTARTS\tAGE\tIMAGE\tSHA"
    kubectl get pods -o=json | jq -r '.items[] | [.metadata.name, ([(.status.containerStatuses | map(select(.ready==true)) | length), (.status.containerStatuses | length)] | join("/")), .status.phase, ([.status.containerStatuses[].restartCount] | join(",")), .metadata.creationTimestamp, ([.status.containerStatuses[].image | split("/") | if length > 1 then .[1:] else . end | join("/") | split(":") | join(":")] | join(",")), ([.status.containerStatuses[].imageID | sub(".*sha256:"; "") | .[0:7]] | join(","))] | @tsv' | while IFS=$'\t' read -r name ready pod_status restarts creationtimestamp image sha; do
        current_epoch=$(date +%s)
        creation_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "${creationtimestamp}" +%s)
        age=$(( (current_epoch - creation_epoch) / 86400 ))d
        echo -e "${name}\t${ready}\t${pod_status}\t${restarts}\t${age}\t${image}\t${sha}"
    done
} | column -t -s $'\t'

    echo
done
