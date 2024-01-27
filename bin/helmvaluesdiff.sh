#!/bin/bash

release=${1?please enter release name}

revision=${2}
compare_revision=${3}

if [ -z "$revision" ]; then
  latestrevisioninfo=$(helm history $release --output json | jq '.[length-1]')

  revision=$( echo $latestrevisioninfo | jq '.revision' )
  updatedate=$( echo $latestrevisioninfo | jq '.updated')
else
  revisioninfo=$(helm history $release --output json | jq ".[] | select(.revision | . == $revision )")
  updatedate=$( echo $revisioninfo | jq '.updated')
fi

# Set the previousrevision or use the specified compare_revision
if [ -z "$compare_revision" ]; then
previousrevision=$(expr $revision - 1)
else
  previousrevision=$compare_revision
fi

echo $previousrevision \> $revision updated at $updatedate

diff <( helm get values $release --all --revision $previousrevision ) <( helm get values $release --all --revision $revision )
