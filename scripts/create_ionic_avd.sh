#!/bin/sh

if [ $# -ne 1 ]
then
    echo "usage: create_ionic_avd.sh <package>"
    exit 1
fi

AVD_PACKAGE="$1"

echo "Creating emulator device."
echo "no" | avdmanager create avd --package "${AVD_PACKAGE}" --name 'ionic-device' --device "android-28"
cat >> "${HOME}/.android/avd/ionic-device.avd/config.ini" <<EOF
hw.lcd.height=1280
hw.lcd.width=720
hw.lcd.density=240
hw.ramSize=1536
hw.device.name=Generic Ionic Device
hw.gps=yes
hw.gpu.enabled=yes
hw.gpu.mode=auto
EOF
