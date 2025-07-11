#!/usr/bin/env bash

# fast_forward_devcontainer.sh
# ---------------------------------------------
# Fast-forward the "devcontainer" branch so that
# it is always up-to-date with the latest commit
# on the "main" branch.
#
# Usage:
#   ./scripts/fast_forward_devcontainer.sh
#
# This script assumes you have push access to the
# repository and that the remote is called "origin".
# ---------------------------------------------

set -euo pipefail

MAIN_BRANCH="main"
EXTRA_BRANCH="devcontainer"
REMOTE="origin"

# Fetch the latest state from the remote
printf "\n[ff-devcontainer] Fetching latest changes from %s…\n" "$REMOTE"
git fetch "$REMOTE"

# Ensure local main is up to date (fast-forward only)
printf "[ff-devcontainer] Updating local %s…\n" "$MAIN_BRANCH"
git checkout "$MAIN_BRANCH"
git merge --ff-only "$REMOTE/$MAIN_BRANCH"

# Create the extra branch locally if it doesn't exist
if ! git rev-parse --verify "$EXTRA_BRANCH" >/dev/null 2>&1; then
  printf "[ff-devcontainer] Branch %s does not exist locally – creating it from %s…\n" "$EXTRA_BRANCH" "$MAIN_BRANCH"
  git checkout -b "$EXTRA_BRANCH" "$MAIN_BRANCH"
else
  git checkout "$EXTRA_BRANCH"
fi

# Fast-forward extra branch to main (remote tracking)
printf "[ff-devcontainer] Fast-forwarding %s to match %s…\n" "$EXTRA_BRANCH" "$MAIN_BRANCH"
# We merge the *remote* main so we don’t need to checkout main again.
git merge --ff-only "$REMOTE/$MAIN_BRANCH"

# Push the updated branch
printf "[ff-devcontainer] Pushing %s to %s…\n" "$EXTRA_BRANCH" "$REMOTE"
git push "$REMOTE" "$EXTRA_BRANCH"

# Return to the original branch (main)
printf "[ff-devcontainer] Returning to %s…\n" "$MAIN_BRANCH"
git checkout "$MAIN_BRANCH"

echo "[ff-devcontainer] Done! The $EXTRA_BRANCH branch now matches $MAIN_BRANCH." 