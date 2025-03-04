#!/bin/bash
set -e

trap catch ERR
trap finally EXIT

function catch {
    echo "ERROR: Stop the process!"
    exit 1
}

function finally {
    exit 0
}

# Get the current branch
branch=$(git rev-parse --abbrev-ref HEAD)

# Get the last tag
last_tag=$(git describe --tags --abbrev=0)

# Get the commit count since the last tag
commit_count=$(git rev-list ${last_tag}..HEAD --count)

# Get the numbers of the version from tag
version_nums=$(echo ${last_tag} | tr -d 'v')
# Get the major, minor, and patch version from the last tag
major=$(echo ${version_nums} | cut -d. -f1)
minor=$(echo ${version_nums} | cut -d. -f2)
patch=$(echo ${version_nums} | cut -d. -f3)
# Get changes
changes=$(git status -s)

if [ -z "${changes}"]; then
    is_change=false
else
    is_change=true
fi

echo "branch=${branch}"
echo "last_tag=${last_tag}"
echo "commit_count=${commit_count}"
echo "major=${major}"
echo "minor=${minor}"
echo "patch=${patch}"
echo "is_change=${is_change}"
