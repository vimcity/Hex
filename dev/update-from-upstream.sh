#!/bin/zsh

set -euo pipefail

repo_root=${0:A:h:h}

cd "$repo_root"

if [[ -n $(git status --short) ]]; then
  printf 'Worktree not clean. Commit or stash changes first.\n' >&2
  exit 1
fi

readme_backup=$(mktemp "${TMPDIR%/}/hex-readme.XXXXXX")
cleanup() {
  rm -f "$readme_backup"
}
trap cleanup EXIT

cp "README.md" "$readme_backup"

git fetch upstream
git merge upstream/main

cp "$readme_backup" "README.md"

if ! git diff --quiet -- README.md; then
  git add README.md
fi

./dev/install-personal.sh
