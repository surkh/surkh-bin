#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 [branch_A] [branch_B]"
    echo "Make branch_A identical to branch_B by adding a new commit."
    exit 1
}

# Check that two arguments are provided
if [ "$#" -ne 2 ]; then
    usage
fi

# Assign command-line arguments to variables
A="$1"
B="$2"

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
