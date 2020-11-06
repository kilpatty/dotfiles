#!/usr/bin/env bash
#
# Run all dotfiles updates.

set -e

cd "$(dirname $0)"/..

# find the installers and run them iteratively
find . -name update.sh | while read installer ; do sh -c "${installer}" ; done
