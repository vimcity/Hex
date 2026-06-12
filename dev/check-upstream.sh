#!/bin/zsh

set -euo pipefail

repo_root=${0:A:h:h}

cd "$repo_root"

git fetch upstream

printf 'Branch and worktree:\n'
git status --short --branch

printf '\nUpstream commits not in current branch:\n'
if git log --oneline HEAD..upstream/main | grep . >/dev/null; then
  git log --oneline HEAD..upstream/main
else
  printf 'None. Current branch includes latest origin/main.\n'
fi

printf '\nLocal-only commits:\n'
if git log --oneline upstream/main..HEAD | grep . >/dev/null; then
  git log --oneline upstream/main..HEAD
else
  printf 'None.\n'
fi
