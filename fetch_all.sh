cd common
echo "Fetching common.."
git fetch manfred && git merge manfred/voting
git status
echo

cd ../p2p
echo "Fetching p2p.."
git fetch manfred && git merge manfred/voting
git status
echo

cd ../assets
echo "Fetching assets.."
git fetch manfred && git merge manfred/voting
git status
echo

cd ../core
echo "Fetching core.."
git fetch manfred && git merge manfred/voting
git status
echo

cd ../grpc
echo "Fetching grpc.."
git fetch manfred && git merge manfred/voting
git status
echo
