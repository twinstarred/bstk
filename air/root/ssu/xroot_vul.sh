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
echo "Fetching environment"
   if [ ! -e /mnt/macos ]; then
        echo "Could not verify environment as BlueStacks Air"
        exit 1
    else
        echo "Environment identified as BlueStacks Air, proceeding"
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
cd /data/local/tmp
echo "Handle binary /system/xbin/bstk/su"
adb shell /system/xbin/bstk/su -c mount -o rw,remount /system
adb shell /system/xbin/bstk/su -c cp -f /system/xbin/bstk/su /system/xbin
adb shell /system/xbin/bstk/su -c mount -o ro,remount /system

echo "Installing SuperSU.apk"
adb install SuperSU.apk

echo "Script succeeded!"
echo "Now, open the SuperSU app and update the binary as per"
echo "the app's request (make sure to choose Normal mode)"
