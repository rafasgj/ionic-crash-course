#!/bin/sh - source'd

. "`dirname "$0"`/functions.sh"

TOOLCHAIN="`pwd`/toolchain"

case $os in
    "Linux")
        export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk"
    ;;
    "Darwin")
        export JAVA_HOME="`/usr/libexec/java_home`"
    ;;
    *)
        echo "Invalid operating system '$os'."
        return 1
    ;;
esac # is ridiculos ;-)

ANDROID_SDK_ROOT="${TOOLCHAIN}/android-sdk/"

if [ -d ${ANDROID_SDK_ROOT} ]
then
    export ANDROID_SDK
    export PATH=${PATH}:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/emulator
fi
