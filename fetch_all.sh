#!/bin/bash
#
# Fetch the latest work in all repos.
#
# todo: seednode should maybe be included
set -eu
echo "Fetching root.."
git fetch manfred && git merge manfred/voting
git status
git push
echo

cd common
echo "Fetching common.."
git fetch manfred && git merge manfred/voting
git status
git push
echo

cd ../desktop
echo "Fetching desktop.."
git fetch manfred && git merge manfred/voting
git status
git push
echo

cd ../p2p
echo "Fetching p2p.."
git fetch manfred && git merge manfred/voting
git status
git push
echo

cd ../assets
echo "Fetching assets.."
git fetch manfred && git merge manfred/voting
git status
git push
echo

cd ../core
echo "Fetching core.."
git fetch manfred && git merge manfred/voting
git status
git push
echo
