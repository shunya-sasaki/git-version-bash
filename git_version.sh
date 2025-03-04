#!/bin/sh

# Get the current branch
branch=$(git rev-parse --abbrev-ref HEAD)

# Get the last tag
last_tag=$(git describe --tags --abbrev=0)

echo "last_tag=${last_tag}"
