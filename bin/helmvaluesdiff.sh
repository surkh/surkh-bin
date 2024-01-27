#!/bin/bash

release=${1?please enter release name}
revision=${2}
compare_revision=${3}

# Fetch and store the helm history once
helm_history=$(helm history $release --output json)

# Function to get updated date and revision number for a given revision
get_revision_info() {
  local rev=$1
  local revinfo=$(echo "$helm_history" | jq ".[] | select(.revision | . == $rev )")
  local updated=$(echo $revinfo | jq '.updated')
  local revision=$(echo $revinfo | jq '.revision')
  echo "$revision|$updated"
}

# Determine the current and previous revisions
if [ -z "$revision" ]; then
  latest_revision_info=$(echo "$helm_history" | jq '.[length-1]')
  revision=$(echo $latest_revision_info | jq '.revision')
fi

if [ -z "$compare_revision" ]; then
  compare_revision=$(expr $revision - 1)
fi

# Get revision info for both revisions
first_revision_info=$(get_revision_info $compare_revision)
second_revision_info=$(get_revision_info $revision)

# Extracting revision numbers and update dates
first_revision=$(echo $first_revision_info | cut -d '|' -f1)
first_revision_update=$(echo $first_revision_info | cut -d '|' -f2)
second_revision=$(echo $second_revision_info | cut -d '|' -f1)
second_revision_update=$(echo $second_revision_info | cut -d '|' -f2)

echo "Comparing revision $first_revision (updated at $first_revision_update) with $second_revision (updated at $second_revision_update)"

# Perform diff in the correct order
diff <(helm get values $release --all --revision $first_revision) <(helm get values $release --all --revision $second_revision)
