#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 [branch_B] [branch_A]"
    echo "If only one argument is provided, it assumes that is the source branch (branch_B), and the current branch is used as the destination (branch_A)."
    echo "If two arguments are provided, the first is the source branch (branch_B) and the second is the destination branch (branch_A)."
    echo "This script creates a new commit on branch_A, making it identical to branch_B."
    exit 1
}

# Check the number of arguments
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    usage
fi

# Assign command-line arguments to variables
B="$1"
if [ "$#" -eq 2 ]; then
    A="$2"
else
    # Get the current branch name
    A=$(git rev-parse --abbrev-ref HEAD)
fi

# Checkout to branch B
git checkout "$B"

# Create a temporary branch as a copy of the current state
git branch temp

# Checkout to branch A
git checkout "$A"

# Perform a squash merge from the temporary branch
git merge --squash temp

# Commit the changes
git commit -m "Made $A identical to $B"

# Delete the temporary branch
git branch -D temp

echo "Branch $A has been updated to match the state of branch $B."
