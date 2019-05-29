# source it! But it requires the Bash shell.

TOOLCHAIN="$(readlink -f "`dirname "$(pwd)/$BASH_SOURCE"`/../toolchain")"

# export JAVA_HOME="${TOOLCHAIN}/jdk1.8.0_211"
export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk"
export ANDROID_SDK_ROOT="${TOOLCHAIN}/android-sdk"
export PATH=${PATH}:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/emulator
