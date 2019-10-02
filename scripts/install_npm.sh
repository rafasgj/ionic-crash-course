#!/bin/sh

SCRIPTDIR="`dirname "$0"`"
. "${SCRIPTDIR}/functions.sh"
os=`uname`

warning_fedora() {
    echo "Could not update NPM, you might check your installation."
    echo "It is known to happen on Fedora 30."
    echo "Installation will continue anyway."
}

echo "Updating NPM dependencies."
if [ "$os" == "Darwin" ]
then
    BREW=`which brew`
    NPM=`which npm`
    [ ! -z "$BREW" -a -z "$NPM" ] && $BREW install node
fi

optional run_as_superuser "npm upgrade -g" "upgrade npm" || warning_fedora

# install Cordova
echo "Installing Cordova."
run_as_superuser "npm install -g cordova" "install Cordova"
# TODO: failed due to EACCESS
if [ "$os" == "Darwin" ]
then
    run_as_superuser "npm install --unsafe-perm=true -g cordova-res" "install Cordova-res"
fi

# install Ionic
echo "Installing Ionic."
run_as_superuser "npm install -g ionic" "install Ionic"

echo "Installing native-run."
run_as_superuser "npm install -g native-run" "install native-run"

if [ "$os" == "Darwin" ]
then
    run_as_superuser "npm install -g ios-sim" "install ios-sim"
    run_as_superuser "npm install --unsafe-perm=true -g ios-deploy" "install ios-deploy"
fi

case "$os" in
    "Linux") USERGROUP="$USER.$GROUP"
    ;;
    "Darwin") USERGROUP="$USER"
    ;;
    *) echo "Invalid operating system: $os"
    exit 1
    ;;
esac # is ridiculous ;-)

[ -d "${HOME}/.npm" ] && run_as_superuser "chown -R "$USERGROUP" ${HOME}/.npm" "fix permissions"
