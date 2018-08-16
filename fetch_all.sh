#!/bin/bash
#
# Fetch the latest work in all repos.
#
set -eu
echo "Fetching root.."
git checkout master
git fetch upstream
git rebase upstream/master
git status
git push
echo

cd common
echo "Fetching common.."
git checkout master
git fetch upstream
git rebase upstream/master
git status
git push
echo

cd ../desktop
echo "Fetching desktop.."
git checkout master
git fetch upstream
git rebase upstream/master
git status
git push
echo

cd ../p2p
echo "Fetching p2p.."
git checkout master
git fetch upstream
git rebase upstream/master
git status
git push
echo

cd ../assets
echo "Fetching assets.."
git checkout master
git fetch upstream
git rebase upstream/master
git status
git push
echo

cd ../core
echo "Fetching core.."
git checkout master
git fetch upstream
git rebase upstream/master
git status
git push
echo

cd ../seednode
echo "Fetching seednode.."
git checkout master
git fetch upstream
git rebase upstream/master
git status
git push
echo
