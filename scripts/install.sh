#!/bin/sh

BASEDIR=$(readlink -f "`dirname $0`/..")
DOWNLOADS="${BASEDIR}/downloads"
TOOLCHAIN="${BASEDIR}/toolchain"
ANDROID_SDK="${BASEDIR}/toolchain/android-sdk"
ANDROID_TOOLS="${BASEDIR}/toolchain/android-sdk/tools"
SDKMANAGER="${ANDROID_TOOLS}/bin/sdkmanager"

os=`uname`
bits=`uname -m | grep '_64'`

if [ "$os" != "Linux" ]
then
    echo "This script was not tested under $os."
    exit 1
fi

if [ ! $EUID == 0 ]
then
    echo "Superuser priviledges required to execute this script."
    exit 1
fi

echo "Updating dependencies."
npm upgrade -g

echo "You must install a Java JDK version 8 or compatible."
echo "It is recommended that you use OpenJDK."
echo "Check its installation to set JAVA_HOME on 'scripts/env.sh'"
echo 'It might be installed at /usr/lib/jvm/java-1.8.0-openjdk'
if [ -e "/usr/lib/jvm/java-1.8.0-openjdk" ]
then
    echo "And yours IS installed there!"
else
    echo "Unfortunatelly you don't have it installed at that directory."
read "Press <ENTER> to continue..." dummy

echo "Installing toolchain for Ionic development."

[ -d "${TOOLCHAIN}"] || mkdir -p "${TOOLCHAIN}"
[ -d "${DOWNLOADS}"] || mkdir -p "${DOWNLOADS}"

echo "Downloading Android SDK Manager."
sdk_tools="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
wget -c "$sdk_tools" -P "${DOWNLOADS}"
unzip "${DOWNLOADS}/`basename ${sdk_tools}`" -d "${TOOLCHAIN}"

echo "Downloading Android SDK Tools"
"${SDKMANAGER}" tools platform-tools

echo "Downloading Android Bulid Tools"
"${SDKMANAGER}" 'build-tools;28.0.3'

echo "Downloading Android Image"
if [ -z "$bits" ]
then
    AVD_PACKAGE='system-images;android-28;google_apis;x86_64'
else
    AVD_PACKAGE='system-images;android-28;google_apis;x86'
fi
"${SDKMANAGER}" "${AVD_PACKAGE}"

# Install 32-bit libraries.
# if [ ! -z "$bits" ]
# then
#     echo "Installing 32-bit libraries."
#     FEDORA_PACKAGES="glibc.i686 glibc-devel.i686 libstdc++.i686 zlib-devel.i686 \
# ncurses-devel.i686 libX11-devel.i686 libXrender.i686 libXrandr.i686"
#     UBUNTU_PACKAGES="lib32z1 lib32ncurses5 lib32bz2-1.0"
#     if [ -e /etc/redhat-release -o -e /etc/fedora-release ]
#     then
#         dnf install -y $FEDORA_PACKAGES
#     elif [ -e /etc/debian-release ]
#     then
#         echo "This script was not tested on Debian based distros."
#         read -p "ENTER to continue at your own risk, or CTRL-C to abort." dummy
#         apt-get install -y $UBUNTU_PACKAGES
#     fi
# fi

# Create an android virtual device
"${BASEDIR}/scripts/create_ionic_avd.sh" "${AVD_PACKAGE}"

# install Cordova
echo "Installing Cordova."
npm install -g cordova

# install Ionic
echo "Installing Ionic."
npm install -g ionic

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
# ionic cordova platform add ios
# ionic cordova build ios

ionic cordova platform add android
ionic cordova build android
ionic cordova emulate android

# Clean up
popd >/dev/null 2>&1
rm -rf ${PROJECT}

echo "Ionic platform installed."
