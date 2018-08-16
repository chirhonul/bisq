#!/bin/bash
cd ~/src/github.com/chirhonul/bisq
while true; do
#  rsync -vaz --exclude build --exclude out --exclude '*.sw?' s2:src/github.com/chirhonul/bisq/ .
  echo "Syncing to s2.."
  rsync -vaz --delete --exclude build --exclude out --exclude '*.sw?' . s2:src/github.com/chirhonul/bisq/
  sleep 5
done
