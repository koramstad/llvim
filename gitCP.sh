#!/bin/bash
# gacp.sh - Git Add, Commit, Push
#
# Usage:
#   ./scripts/gacp.sh "Your commit message"
#

if [ -z "$1" ]; then
    echo "Error: Commit message required"
    echo "Usage: $0 \"Your commit message\""
    exit 1
fi

git add . && \
git commit -m "$1" && \
git push -u origin main
