#!/bin/sh

. "`dirname "$0"`/functions.sh"

BASEDIR=$(pwd)

DOWNLOADS="${BASEDIR}/downloads"
TOOLCHAIN="${BASEDIR}/toolchain"

ANDROID_SDK="${TOOLCHAIN}/android-sdk"
ANDROID_TOOLS="${ANDROID_SDK}/tools"
SDKMANAGER="${ANDROID_TOOLS}/bin/sdkmanager"

echo "Verifying instalation environment."

[ -d "${TOOLCHAIN}" ] || mkdir -p "${TOOLCHAIN}"
[ -d "${DOWNLOADS}" ] || mkdir -p "${DOWNLOADS}"

echo "Installing Android Development Toolchain."

echo "You must install a Java JDK version 8 or compatible."
if [ "$os" == "Linux" ]
then
    echo "It is recommended that you use OpenJDK."
    echo "Check its installation to set JAVA_HOME on 'scripts/env.sh'"
    echo 'It might be installed at /usr/lib/jvm/java-1.8.0-openjdk'
    if [ -e "/usr/lib/jvm/java-1.8.0-openjdk" ]
    then
        echo "And yours IS installed there!"
    else
        echo "Unfortunatelly you don't have it installed at that directory."
    fi
elif [ "$os" == "Darwin" ]
then
    echo "You are running `java -version 2>&1 | sed -n "1p"`"
    echo "Set JAVA_HOME to `/usr/libexec/java_home`"
    BREW=`which brew`
    if [ ! -z "$BREW" ]
    then
        GRADLE=`which gradle`
        if [ -z "$GRADLE" ]
        then
            echo "Installing Gradle."
            "$BREW" install gradle || exit 1
        fi
    else
        echo "Install Gradle with Homebrew: \`brew install gradle\`"
        exit 1
    fi
fi
echo "Press <ENTER> to continue..."
read dummy

echo "Downloading Android SDK Manager."
sdkos=`echo "$os" | tr "[:upper:]" "[:lower:]"`
sdk_tools="https://dl.google.com/android/repository/sdk-tools-$sdkos-4333796.zip"
# wget -c "$sdk_tools" -P "${DOWNLOADS}"
sdk_file="${DOWNLOADS}/`basename ${sdk_tools}`"
echo "curl -o \"${sdk_file}\" \"$sdk_tools\""
curl -o "${sdk_file}" "$sdk_tools" || exit 1
mkdir -p "${ANDROID_SDK}" >/dev/null 2>&1
unzip "${sdk_file}" -d "${ANDROID_SDK}" || exit 1

echo "Downloading Android SDK Tools"
"${SDKMANAGER}" tools platform-tools || exit 1

echo "Downloading Android Bulid Tools"
"${SDKMANAGER}" 'build-tools;28.0.3' || exit 1

echo "Downloading Android Platform"
"${SDKMANAGER}" 'platforms;android-28'|| exit 1

echo "Downloading Android Images"
bits=`uname -m | grep '_64'`
AVD_PACKAGE='system-images;android-28;google_apis;x86_64'
"${SDKMANAGER}" "${AVD_PACKAGE}" || exit 1
AVD_PACKAGE='system-images;android-28;google_apis;x86'
"${SDKMANAGER}" "${AVD_PACKAGE}" || exit 1

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
"${SCRIPTDIR}/create_ionic_avd.sh" "${AVD_PACKAGE}" || exit 1
