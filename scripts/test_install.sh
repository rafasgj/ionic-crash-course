#!/bin/sh

SCRIPTDIR="`dirname "$0"`"

# Prepare development environment.
echo "Preparing build environment."
. "${SCRIPTDIR}/env.sh"

# Create a dummy project to configure Ionic.
PROJECT="MyFirstProject"
LOGFILE="install-test.log"
echo "Testing project build and run."
echo "Output will be redirected to '${LOGFILE}'."
echo "Creating project." | tee ${LOGFILE}
echo "This might need to install dependencies and take several minutes." | tee -a ${LOGFILE}
echo "n" | ionic start --type=angular "${PROJECT}" blank >> ${LOGFILE} 2>&1 || exit 1
pushd "${PROJECT}" >/dev/null 2>&1

echo "Enabling Android development." | tee -a ${LOGFILE}
ionic cordova platform add android >> ${LOGFILE} 2>&1 || exit 1
echo "Building test project for Android." | tee -a ${LOGFILE}
ionic cordova build android >> ${LOGFILE} 2>&1 || exit 1
echo "Testing Android project (this might take a looong time.)" | tee -a ${$LOGFILE}
echo "Close the emulator after you see it running an empty app." | tee -a ${LOGFILE}
ionic cordova emulate android --no-native-run >> ${LOGFILE} 2>&1 || exit 1

# Only enable iOS on macOS.
if [ "$os" == "Darwin" ]
then
    echo "Adding platform iOS to the project." | tee -a ${LOGFILE}
    ionic cordova platform add ios >> ${LOGFILE} 2>&1 || exit 1
    ionic cordova prepare ios >> ${LOGFILE} 2>&1 || exit 1
    echo "Building test project for iOS" | tee -a ${LOGFILE}
    ionic cordova build ios >> ${LOGFILE} 2>&1 || exit 1
    echo "Testing iOS project (this might take a looong time.)" | tee -a ${LOGFILE}
    echo "Close the emulator after you see it running an empty app." | tee -a ${LOGFILE}
    ionic cordova emulate ios --no-native-run >> ${LOGFILE} 2>&1 || exit 1
fi

# Clean up
popd >/dev/null 2>&1
rm -rf ${PROJECT} ${LOFGILE}
