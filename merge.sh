#!/bin/bash


if (( $# != 0 )); then
    echo "usage: `basename $0` "
    echo "     merges in the repos listed, relocating them to a dir named for the repo"
    echo "     while re-writing the history to retain the file changes."
    echo "     The filter-branch is expensive on disk IO and hence runs best on a tmpfs mount"
    exit
fi

# N.B. set -eu bombs out on some operations that do not report (like rm)
set -u

# TODO create the target repo here
# and cd into that dir
TARGET=merge-result


function move_in_subdir () {
          git filter-branch --prune-empty --tree-filter '
  if [[ ! -e '"$1"' ]]; then
    mkdir -p '"$1"'
    git ls-tree --name-only $GIT_COMMIT | xargs -I files mv files '"$1"'
  fi'
}

function merge_repo() {
    echo "===== about to clone " $PWD
    # create git clone if pulling from remote here
    cd "$1"

    git remote rm origin
    mkdir "$1"
    move_in_subdir "$1"
    git commit -m "Prepare $1 to merge in"
    cd ../$TARGET
    echo "==== about to pull " $PWD
    git remote add "$1" ../"$1"
    git pull --allow-unrelated-histories --no-edit "$1" master
    git remote rm "$1"
    cd ../
    rm -rf "$1"
}

merge_repo project-a
merge_repo project-b


