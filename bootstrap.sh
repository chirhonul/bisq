#!/bin/sh
#
# Initialize Bisq repos and fetch necessary dependencies for development.
#
set -eu

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
BISQ_ROOT=${BISQ_ROOT:-"${SCRIPT_DIR}"}
REPO_USER=${REPO_USER:-"chirhonul"}
# todo: run on different server.
BINARIES_SERV=${BINARIES_SERV:-"http://145.249.106.170"}
BINARIES_SIGN_EMAIL=${BINARIES_SIGN_EMAIL:-"chinul@disroot.org"}
BINARIES_SIGN_KEY=${BINARIES_SIGN_KEY:-"BB82 36D1 3081 1401 7253  727F 4600 E7D2 101E A2E4"}
BINARIES_DIR=${BINARIES_DIR:-"${HOME}/bin"}

mkdir -p ${BISQ_ROOT} ${BINARIES_DIR}

# use: $1 some-tool
must_have() {
  if ! which ${1} 2>&1 >/dev/null; then
    echo "failing; this script requires '${1}' to be installed." 1>&2
    return 1
  fi
  return 0
}


fetch_binaries() {
  if ! gpg --fingerprint ${BINARIES_SIGN_EMAIL} | grep -q "$BINARIES_SIGN_KEY"; then
    echo "Fetching PGP key '${BINARIES_SIGN_KEY}'.."
    gpg --recv-keys "${BINARIES_SIGN_KEY}"
  fi

  cd ${BINARIES_DIR}
  [ -e SHA256SUMS.asc ] || {
    echo "Fetching SHA256SUMS.asc.."
    curl -LO ${BINARIES_SERV}/SHA256SUMS.asc
  }
  # TODO: could choose to not do this on each run to stay idempotent..
  echo "Verifying PGP signature on SHA256SUMS.asc.."
  gpg --verify SHA256SUMS.asc # note: exits non-success and terminates script on bad sig
  
  echo "Fetching binaries to ${BINARIES_DIR}'.."
  checksums=$(grep -E "[0-9a-f]{64}" SHA256SUMS.asc)
  files=$(echo "$checksums" | awk '{print $2}')
  for file in ${files}; do
    [ -e ${file} ] || {
      echo "Fetching ${file}.."
      curl -LO ${BINARIES_SERV}/${file}
    }
  done
  echo "Verifying integrity of binaries via checksum.."
  echo "${checksums}" | sha256sum -c -
}

install_java() {
  if which java 2>&1 >/dev/null; then
    echo "Java is already installed:"
    echo "$(javac -version)"
    # TODO: could check if installed version is the specific one we know works and warn otherwise.
    return 0
  fi
  cd ${BINARIES_DIR}
  [ -d /usr/lib/jvm/ ] || {
    echo "Creating /usr/lib/jvm/.."
    sudo mkdir -p /usr/lib/jvm/
  }
  uid=$(id -u)
  gid=$(id -g)
  echo "Installing java for user:group ${uid}:${gid}.."
  sudo bash -c " \
    cp jdk-8u172-linux-x64.tar.gz /usr/lib/jvm/ && \
    cd /usr/lib/jvm/ && \
    tar xzfv jdk-8u172-linux-x64.tar.gz && \
    chown -R ${uid}:${gid} /usr/lib/jvm/" # TODO: less wide ownership of dir would be nice.
  echo "Java has been installed. You may want to add it to your PATH and specify JAVA_HOME:"
  echo 'echo export PATH=${PATH}:/usr/lib/jvm/jdk1.8.0_172/bin >> ~/.bashrc'
  echo 'echo export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_172 >> ~/.bashrc'
}

install_gradle() {
  if which gradle 2>&1 >/dev/null; then
    echo "Gradle is already installed:"
    echo "$(gradle -version)"
    # TODO: could check if installed version is the specific one we know works and warn otherwise.
    return 0
  fi

  [ -d /opt/gradle/gradle-4.6 ] && {
    echo "Gradle is already installed:"
    echo "$(gradle -version)"
    echo "However it is not on PATH. You may want to add it to your PATH:"
    echo 'echo export PATH=$PATH:/opt/gradle/gradle-4.6/bin >> ~/.bashrc'
    return 0
  } 
  cd ${BINARIES_DIR}
  sudo bash -c " \
    mkdir -p /opt/gradle && \
    unzip -d /opt/gradle/ gradle-4.6-bin.zip" 
  echo "Gradle has been installed. You may want to add it to your PATH:"
  echo 'echo export PATH=$PATH:/opt/gradle/gradle-4.6/bin >> ~/.bashrc'
}

install_intellij() {
  cd ${BINARIES_DIR}
  [ -d idea ] && { 
    echo "The intellij IDE is already installed in ${BINARIES_DIR}/idea/. Start it by running the idea.sh script."
    return 0
  }
  echo "Installing intellij.."
  tar xzfv ideaIC-*.tar.gz
  mv idea-IC-*/ idea/
  echo "The intelliJ IDE has been installed in ${BINARIES_DIR}/idea. Start it by running the idea.sh script."
}

clone_repo() {
  local repo
  local dir
  local branch
  repo=${1}
  dir=${2}
  branch=${3}
  [ -d ${dir} ] && {
    echo "Already have repo ${repo} present as ${dir}, continuing.."
    return 0
  }
  echo "Cloning ${repo} as ${dir}.."
  git clone https://github.com/${REPO_USER}/${repo} ${dir}
  cd ${dir}
  git remote add upstream https://github.com/bisq-network/${repo}
  git remote add manfred https://github.com/manfredkarrer/${repo}
  git checkout ${branch}
  cd ..
  return 0
}

install_bisq_env() {
  must_have curl
  must_have git
  must_have gpg
  must_have unzip

  cd ${BISQ_ROOT}
  clone_repo bisq-common common voting
  clone_repo bisq-core core voting
  clone_repo bisq-p2p p2p voting
  clone_repo bisq-assets assets voting
  clone_repo bisq-desktop desktop voting

  fetch_binaries

  install_java
  install_gradle
  install_intellij
  # todo: install all the stuff gradle pulls down here? it's significant amounts of data, from various sources..

  echo "Done. You can try building the project with 'gradle build' at this time."
}

install_bisq_env
# todo: need to do gradle install in core, p2p, assets, common
