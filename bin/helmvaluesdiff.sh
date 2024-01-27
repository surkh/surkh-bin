#!/bin/bash

release=${1?please enter release name}
revision=${2}
compare_revision=${3}

# Function to get updated date for a given revision
get_updated_date() {
  local rev=$1
  local revinfo=$(helm history $release --output json | jq ".[] | select(.revision | . == $rev )")
  echo $(echo $revinfo | jq '.updated')
}

if [ -z "$revision" ]; then
  latestrevisioninfo=$(helm history $release --output json | jq '.[length-1]')
  revision=$(echo $latestrevisioninfo | jq '.revision')
fi

# Set the previousrevision or use the specified compare_revision
if [ -z "$compare_revision" ]; then
  previousrevision=$(expr $revision - 1)
else
  previousrevision=$compare_revision
fi

# Determine the order of revisions for diff and get update dates
if [ $previousrevision -lt $revision ]; then
  firstrevision=$previousrevision
  secondrevision=$revision
else
  firstrevision=$revision
  secondrevision=$previousrevision
fi

firstrev_update=$(get_updated_date $firstrevision)
secondrev_update=$(get_updated_date $secondrevision)

echo "Comparing revision $firstrevision (updated at $firstrev_update) with $secondrevision (updated at $secondrev_update)"

# Perform diff in the correct order
diff <(helm get values $release --all --revision $firstrevision) <(helm get values $release --all --revision $secondrevision)
