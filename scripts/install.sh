#!/usr/bin/env bash

SCRIPTDIR="`dirname "$0"`"

. "${SCRIPTDIR}/functions.sh"

BASEDIR="$(pwd)"

DOWNLOADS="${BASEDIR}/downloads/"
TOOLCHAIN="${BASEDIR}/toolchain/"

USER=`id -un`
GROUP=`id -gn`

os=`uname`

if [ "$os" != "Linux" -a "$os" != "Darwin" ]
then
    echo "This script was not tested under $os."
    exit 1
fi

echo "Installing toolchain for Ionic development."

[ -d "${TOOLCHAIN}" ] || mkdir -p "${TOOLCHAIN}"
[ -d "${DOWNLOADS}" ] || mkdir -p "${DOWNLOADS}"

echo "Starting Android toolchain instalation."
"${SCRIPTDIR}/android.sh" || exit 1
echo "Android development toolchain installed."

if [ "$os" == "Darwin" ]
then
    echo "Verifying iOS toolchain instalation."
    XCODE=`which xcode-select`
    if [ -z "$XCODE" ]
    then
        echo "iOS support not installed. Install Xcode to support iOS."
    else
        echo "iOS development toolchain installed."
    fi
fi

. "${SCRIPTDIR}/install_npm.sh"
. "${SCRIPTDIR}/test_install.sh"

echo "Ionic platform installed."
