#!/bin/sh

. "`dirname "$0"`/functions.sh"

BASEDIR="$(pwd)"
DOWNLOADS="${BASEDIR}/downloads/"
TOOLCHAIN="${BASEDIR}/toolchain/"

USER=`id -un`
GROUP=`id -gn`

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

echo "Updating NPM dependencies."
if [ "$os" == "Darwin" ]
then
    BREW=`which brew`
    NPM=`which npm`
    [ ! -z "$BREW" -a -z "$NPM" ] && $BREW install node
fi

run_as_superuser "npm upgrade -g" "upgrade npm"

# install Cordova
echo "Installing Cordova."
run_as_superuser "npm install -g cordova" "install Cordova"
if [ "$os" == "Darwin" ]
then
    run_as_superuser "npm install -g cordova-res" "install Cordova-res"
fi

# install Ionic
echo "Installing Ionic."
run_as_superuser "npm install -g ionic" "install Ionic"

echo "Installing native-run."
run_as_superuser "npm install -g native-run" "install native-run"

[ -d "${HOME}/.npm" ] && run_as_superuser "chown -R $USER.$GROUP ${HOME}/.npm" "fix permissions"

# Prepare development environment.
echo "Preparing build environment."
. "`dirname "$0"`/env.sh"

# Create a dummy project to configure Ionic.
PROJECT="MyFirstProject"
LOGFILE="install-test.log"
echo "Testing project build and run."
echo "Output will be redirected to '${LOGFILE}'."
echo "Creating project." | tee ${LOGFILE}
echo "n" | ionic start "${PROJECT}" blank --type ionic1
pushd "${PROJECT}" >/dev/null 2>&1

echo "Enabling Android development." | tee -a ${LOGFILE}
ionic cordova platform add android >> ${LOGFILE} || exit 1
echo "Building test project for Android." | tee -a ${LOGFILE}
ionic cordova build android >> ${LOGFILE} || exit 1
echo "Testing Android project (this will take a looong time.)" | tee -a ${$LOGFILE}
echo "Close the emulator after you see it running an empty app." | tee -a ${LOGFILE}
ionic cordova emulate android --no-native-run >> ${LOGFILE} || exit 1

# Only enable iOS on macOS.
if [ "$os" == "Darwin" ]
then
    echo "Adding platform iOS to the project." | tee -a ${LOGFILE}
    ionic cordova platform add ios >> ${LOGFILE} || exit 1
    echo "Building test project for iOS" | tee -a ${LOGFILE}
    ionic cordova build ios >> ${LOGFILE} || exit 1
fi

# Clean up
popd >/dev/null 2>&1
rm -rf ${PROJECT} ${LOFGILE}

echo "Ionic platform installed."

