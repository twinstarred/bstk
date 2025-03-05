#!/system/bin/sh
check_adb_devices() {
    adb_status=$(adb shell echo "check" 2>&1)
    if echo "$adb_status" | grep -q "error: closed"; then
        echo "ADB connection closed. Enable ADB in Settings > Advanced"
        exit 1
    else
        echo "Found device;"
        adb devices
    fi
}

echo
echo " -- STAGE 1 --"
if [ ! -e ~/downloads ]; then
    mkdir ~/downloads
    fi

echo "Fetching environment"
   if [ ! -e /mnt/macos ]; then
        echo "Could not verify environment as BlueStacks Air"
        exit 1
    else
        echo "Environment identified as BlueStacks Air, proceeding"
        fi

if [ ! -e /data/data/com.termux/files/home/storage ]; then
echo
echo "Running termux-setup-storage,"
echo "You will be prompted to give Termux access to all files"
echo "in the system."
echo "The terminal will sleep for 12 seconds."
    termux-setup-storage
    sleep 12
    fi

echo "Searching for git"
    if [ ! -e /data/data/com.termux/files/usr/bin/git ]; then
        echo "Installing git"
        pkg install -y git 2>/dev/null >/dev/null;
    else
        echo "Found git, skipping"
        fi

echo "Searching for android-tools"
    if [ ! -e /data/data/com.termux/files/usr/bin/adb ]; then
        echo "Installing android-tools"
        pkg install -y android-tools 2>/dev/null >/dev/null;
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

echo "Fetching files from twinstarred/air/root/ssu"
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
echo "Placing su binary & its associated files"
/data/local/tmp/su -c echo "Current user: $(/data/local/tmp/su -c whoami)"
/data/local/tmp/su -c mount -o rw,remount /system
    if [ ! -e /system/xbin ]; then
        /data/local/tmp/su -c mkdir /system/xbin
        fi
/data/local/tmp/su -c mv -f /data/local/tmp/su /system/xbin/su
/system/xbin/su -c mv -f /data/local/tmp/daemonsu /system/xbin/daemonsu
/system/xbin/su -c mv -f /data/local/tmp/supolicy /system/xbin/supolicy
/system/xbin/su -c mount -o ro,remount /system

echo "Installing SuperSU.apk"
adb install /data/local/tmp/SuperSU.apk

echo
echo "Successfully finished all operations!"
echo "BlueStacks Air is now rooted (2.79:SUPERSU)"
