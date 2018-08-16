#!/bin/bash
#
# Builds the entire bisq project.
#
set -eu

cd common
echo "Building common.."
./gradlew generateproto
./gradlew install
echo

# todo: try fat jar build if doing separate steps continue to have issues:
#  cd desktop && ./gradlew --include-build ../common --include-build ../p2p --include-build ../core build -x test shadowJar

cd ../p2p
echo "Building p2p.."
./gradlew install
echo

cd ../assets
echo "Building assets.."
./gradlew install
echo

cd ../core
echo "Building core.."
./gradlew install
echo
