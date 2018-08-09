cd common
echo "Building common.."
./gradlew generateproto
./gradlew install
echo

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
