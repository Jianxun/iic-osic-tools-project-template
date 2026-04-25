#!/bin/bash

# Script to remove a git subodule completly
# Usage: ./remove_submodule.sh <path_submodule>
#

if [ $# -eq 0 ]; then
    echo "Need to provide the module path."
		echo "Example: ./remove_submodule.sh designs/libs/gLayout"
    exit 1
fi

SUBMODULE_PATH=$1

FULL_PATH=$( realpath $SUBMODULE_PATH )
CURRENT_PATH=$( pwd )
RELATIVE_PATH=${FULL_PATH#$CURRENT_PATH/}
REPO_ROOT=$( git rev-parse --show-toplevel  )

echo $RELATIVE_PATH

git submodule deinit -f $SUBMODULE_PATH
git rm -f $SUBMODULE_PATH
rm -rf "${REPO_ROOT}/.git/modules/${RELATIVE_PATH}"
