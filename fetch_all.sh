echo "Fetching root.."
git fetch manfred && git merge manfred/voting
git status
git push
echo

# todo: try fat jar build if having issues still:
#  ./gradlew --include-build ../common --include-build ../assets --include-build ../p2p --include-build ../core build -x test shadowJar
# todo: seednode should maybe be included

cd common
echo "Fetching common.."
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
