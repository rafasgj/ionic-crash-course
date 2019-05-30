#!/bin/sh

. "`dirname "$0"`/functions.sh"

BASEDIR="$(pwd)"
DOWNLOADS="${BASEDIR}/downloads/"
TOOLCHAIN="${BASEDIR}/toolchain/"

if [ "$os" != "Linux" -a "$os" != "Darwin" ]
then
    echo "This script was not tested under $os."
    exit 1
fi

echo "Updating dependencies."
if [ "$os" == "Darwin" ]
then
    BREW=`which brew`
    NPM=`which npm`
    [ ! -z "$BREW" -a -z "$NPM" ] && $BREW install node
fi

run_as_superuser "npm upgrade -g" "upgrade npm"
run_as_superuser "chown -R $USER.$GROUP '${HOME}/.npm'" "fixing permissions"
echo "Installing toolchain for Ionic development."

[ -d "${TOOLCHAIN}" ] || mkdir -p "${TOOLCHAIN}"
[ -d "${DOWNLOADS}" ] || mkdir -p "${DOWNLOADS}"

echo "Starting Android toolchain instalation."
"${SCRIPTDIR}/android.sh" || exit 1
echo "Android development toolchain installed."

if [ "$os" == "Darwin" ]
then
    echo "Verifying macOS/iOS toolchain instalation."
    XCODE=`which xcode-select`
    if [ -z "$XCODE" ]
    then
        echo "macOS/iOS support not installed. Install Xcode first."
    else
        echo "macOS/iOS development toolchain installed."
    fi
fi

# install Cordova
echo "Installing Cordova."
run_as_superuser "npm install -g cordova" "install Cordova"
run_as_superuser "chown -R $USER.$GROUP '${HOME}/.npm'" "fix permissions"

# install Ionic
echo "Installing Ionic."
run_as_superuser "npm install -g ionic" "install Ionic"
run_as_superuser "chown -R $USER.$GROUP '${HOME}/.npm'" "fix permissions"

# Create a dummy project to configure Ionic.
PROJECT="MyFirstProject"
echo "Configuring Ionic."
echo "n" | ionic start "${PROJECT}" blank --type ionic1
pushd "${PROJECT}" >/dev/null 2>&1

echo "Enabling Android development."
ionic cordova platform add android
echo "Building test project for Android."
ionic cordova build android
echo "Testing Android project (this will take a looong time.)"
echo "Close the emulator after you see it running an empty app."
ionic cordova emulate android

# Only enable iOS on macOS.
if [ "$os" == "Darwin" ]
then
    ionic cordova platform add ios
    ionic cordova build ios
fi

ionic cordova platform add android
ionic cordova build android
ionic cordova emulate android

# Clean up
popd >/dev/null 2>&1
rm -rf ${PROJECT}

echo "Ionic platform installed."
