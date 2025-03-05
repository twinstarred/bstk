#!/system/bin/sh

check_adb_devices() {
    devices_output=$(adb devices | grep -w "emulator")

    if [ -z "$devices_output" ]; then
        echo "Couldn't find device. Enable ADB in Settings > Advanced"
        exit 1
    else
        echo "Found device:"
        echo "$devices_output"
    fi
}

echo
echo " -- STAGE 1 --"
echo "Fetching environment"
   if [ ! -e /mnt/macos ]; then
        echo "Could not verify environment as BlueStacks Air"
        exit 1
    else
        echo "Environment identified as BlueStacks Air, proceeding"
        fi

if [ ! -e /data/data/com.termux/files/home/storage ]; then
echo "Running termux-setup-storage,"
echo "You will be prompted to give Termux access"
echo "to all files in the system"
    termux-setup-storage

echo "Searching for git"
    if [ ! -e /data/data/com.termux/files/usr/bin/git ]; then
        echo "Installing git"
        pkg install git
    else
        echo "Found git, skipping"
        fi

echo "Searching for android-tools"
    if [ ! -e /data/data/com.termux/files/usr/bin/adb ]; then
        echo "Installing android-tools"
        pkg install android-tools
    else
        echo "Found android-tools, skipping"
        fi

echo "Looking for device"
    check_adb_devices

echo
echo " -- STAGE 2 -- "
adb shell mkdir -p /sdcard/tmp/bstk
mkdir ~/downloads/bstk
cd ~/downloads/bstk

echo "Fetching tmp from twinstarred/air/root/ssu"
    git clone -q -n https://github.com/twinstarred/bstk --depth 1
    cd bstk
    git checkout HEAD air/root/ssu/tmp

echo "Handling su binary"
cp -rf air/root/ssu/tmp /sdcard/tmp/bstk
mv ~/downloads/bstk/bstk/air/root/ssu/tmp/su /sdcard/tmp/bstk/tmp/su

rm -rf ~/downloads/bstk/bstk
rm -r ~/downloads/bstk

adb shell mv -f /sdcard/tmp/bstk/tmp/* /data/local/tmp
adb shell mv -f /sdcard/tmp/bstk/tmp/su /data/local/tmp

adb shell chmod 755 /data/local/tmp/su # we now gained root access by /data/local/tmp/su
adb shell chmod 755 /data/local/tmp/SuperSU.apk

# the supersu app will be installed after moving the su binary to
# /system/xbin, as the permission popup interferes with the script.
# i know you can just tap "grant", but this script is intended to be
# as cozy as possible
echo
echo " -- STAGE 3 --"
echo "Placing su binary"
/data/local/tmp/su -c echo "(Current user: $(/data/local/tmp/su -c whoami))"
/data/local/tmp/su -c mount -o rw,remount /system
    if [ ! -e /system/xbin ]; then
        /data/local/tmp/su -c mkdir /system/xbin
        fi
/data/local/tmp/su -c mv -f /data/local/tmp/su /system/xbin/su
/data/local/tmp/su -c mount -o ro,remount /system
adb install /data/local/tmp/SuperSU.apk

echo "Successfully finished all operations!"
echo "BlueStacks Air is now rooted"
