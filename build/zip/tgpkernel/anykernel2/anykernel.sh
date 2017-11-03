# -------------------------------
# TGPKERNEL AROMA INSTALLER 4.6.1
# anykernel2 portion
#
# Anykernel2 created by @osm0sis
# Everything else done by @djb77
#
# DO NOT USE ANY PORTION OF THIS
# CODE WITHOUT MY PERMISSION!!
# -------------------------------

## AnyKernel setup
properties() {
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=herolte
device.name2=hero2lte
device.name3=
device.name4=
device.name5=
}

# Shell Variables
block=/dev/block/platform/155a0000.ufs/by-name/BOOT
ramdisk=/tmp/anykernel/ramdisk
split_img=/tmp/anykernel/split_img
patch=/tmp/anykernel/patch
is_slot_device=0
ramdisk_compression=auto

# S8 Port Variables
S8OSLEVEL=2017-12

# N8 Port Variables
N8OSLEVEL=2018-02
N8OSVERSION=7.1.1

# Extra 0's needed for CPU Freqs
ZEROS=000

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh

## AnyKernel install
ui_print "- Extracing Boot Image"
dump_boot

# Ramdisk changes - S8 Port
if egrep -q "install=1" "/tmp/aroma/check_s8.prop"; then
	ui_print "- Patching for S8 Port ROMs"
	echo $S8OSLEVEL > $split_img/boot.img-oslevel
	if egrep -q "install=1" "/tmp/aroma/g930x.prop"; then
		sed -i -- 's/G955/G950/g' $patch/ramdisk-s8/default.prop
		sed -i -- 's/dream2lte/dreamlte/g' $patch/ramdisk-s8/default.prop
	fi
	cp -rf $patch/ramdisk-s8/* $ramdisk
	chmod 644 $ramdisk/oem/secure_storage/ss_config
	chmod 755 $ramdisk/sbin/adbd
	chmod 755 $ramdisk/sbin/bgcompact
	chmod 755 $ramdisk/sbin/cbd
	chmod 755 $ramdisk/sbin/healthd
	chmod 755 $ramdisk/sbin/knox_changer
	chmod 755 $ramdisk/sbin/sswap
	chmod 644 $ramdisk/default.prop
	chmod 644 $ramdisk/file_contexts.bin
	chmod 755 $ramdisk/init
	chmod 755 $ramdisk/init.rc
	chmod 755 $ramdisk/init.carrier.rc
	chmod 755 $ramdisk/init.environ.rc
	chmod 755 $ramdisk/init.samsungexynos8890.rc
	chmod 755 $ramdisk/init.usb.configfs.rc
	chmod 755 $ramdisk/init.wifi.rc
	chmod 644 $ramdisk/property_contexts
	chmod 644 $ramdisk/seapp_contexts
	chmod 644 $ramdisk/sepolicy
	chmod 644 $ramdisk/sepolicy_version
	chmod 644 $ramdisk/service_contexts
	chmod 644 $ramdisk/ueventd.rc
	chmod 644 $ramdisk/ueventd.samsungexynos8890.rc
fi

# Ramdisk changes - Note 8 Port
if egrep -q "install=1" "/tmp/aroma/check_n8.prop"; then
	ui_print "- Patching for Note 8 Port ROMs"
	echo $N8OSLEVEL > $split_img/boot.img-oslevel
	echo $N8OSVERSION > $split_img/boot.img-osversion
	cp -rf $patch/ramdisk-n8/* $ramdisk
	chmod 644 $ramdisk/oem/secure_storage/ss_config
	chmod 755 $ramdisk/sbin/adbd
	chmod 755 $ramdisk/sbin/bgcompact
	chmod 755 $ramdisk/sbin/cbd
	chmod 755 $ramdisk/sbin/healthd
	chmod 755 $ramdisk/sbin/knox_changer
	chmod 755 $ramdisk/sbin/sswap
	chmod 644 $ramdisk/default.prop
	chmod 644 $ramdisk/file_contexts.bin
	chmod 755 $ramdisk/init
	chmod 755 $ramdisk/init.rc
	chmod 755 $ramdisk/init.baseband.rc
	chmod 755 $ramdisk/init.carrier.rc
	chmod 755 $ramdisk/init.environ.rc
	chmod 755 $ramdisk/init.rilchip.rc
	chmod 755 $ramdisk/init.samsungexynos8890.rc
	chmod 755 $ramdisk/init.usb.configfs.rc
	chmod 755 $ramdisk/init.usb.rc
	chmod 755 $ramdisk/init.wifi.rc
	chmod 755 $ramdisk/init.zygote32.rc
	chmod 755 $ramdisk/init.zygote64_32.rc
	chmod 644 $ramdisk/property_contexts
	chmod 644 $ramdisk/seapp_contexts
	chmod 644 $ramdisk/sepolicy
	chmod 644 $ramdisk/sepolicy_version
	chmod 644 $ramdisk/service_contexts
	chmod 644 $ramdisk/ueventd.ranchu.rc
	chmod 644 $ramdisk/ueventd.rc
	chmod 644 $ramdisk/ueventd.samsungexynos8890.rc
fi

# Ramdisk changes - New Files
ui_print "- Adding TGPKernel Mods"
cp -rf $patch/mods/* $ramdisk
chmod 755 $ramdisk/sbin/initd.sh
chmod 755 $ramdisk/sbin/kernelinit.sh
chmod 755 $ramdisk/sbin/resetprop
chmod 755 $ramdisk/sbin/wakelock.sh
chmod 755 $ramdisk/init.services.rc
insert_line init.rc "import /init.services.rc" after "import /init.fac.rc" "import /init.services.rc"

# Ramdisk changes - SELinux Enforcing Mode
if egrep -q "install=1" "/tmp/aroma/selinux.prop"; then
	ui_print "- Enabling SELinux Enforcing Mode"
	replace_string sbin/kernelinit.sh "setenforce 1" "setenforce 0" "setenforce 1"
	replace_string sbin/kernelinit.sh "# chmod 640 /sys/fs/selinux/enforce" "chmod 640 /sys/fs/selinux/enforce" "# chmod 640 /sys/fs/selinux/enforce"
	replace_string sbin/kernelinit.sh "chmod 644 /sys/fs/selinux/enforce" "chmod 640 /sys/fs/selinux/enforce" "chmod 644 /sys/fs/selinux/enforce"
fi

# Ramdisk changes - Insecure ADB
if egrep -q "install=1" "/tmp/aroma/insecureadb.prop"; then
	ui_print "- Enabling Insecure ADB"
	replace_string default.prop "ro.adb.secure=0" "ro.adb.secure=1" "ro.adb.secure=0"
fi

# Ramdisk changes - Spectrum
if egrep -q "install=1" "/tmp/aroma/spectrum.prop"; then
	ui_print "- Adding Spectrum"
	cp -rf $patch/spectrum/* $ramdisk
	chmod 644 $ramdisk/init.spectrum.rc
	chmod 644 $ramdisk/init.spectrum.sh
	insert_line init.rc "import /init.spectrum.rc" after "import /init.services.rc" "import /init.spectrum.rc"
fi

# Ramdisk changes - PWMFix
if egrep -q "install=1" "/tmp/aroma/pwm.prop"; then
	ui_print "- Enabling PWMFix by default"
	replace_string sbin/kernelinit.sh "echo \"1\" > /sys/class/lcd/panel/smart_on" "echo \"0\" > /sys/class/lcd/panel/smart_on" "echo \"1\" > /sys/class/lcd/panel/smart_on"
fi

# Ramdisk Advanced Options
if egrep -q "install=1" "/tmp/aroma/advanced.prop"; then

# Ramdisk changes for CPU Governors (Big)
	sed -i -- "s/governor-big=//g" /tmp/aroma/governor-big.prop
	GOVERNOR_BIG=`cat /tmp/aroma/governor-big.prop`
	if [[ "$GOVERNOR_BIG" != "interactive" ]]; then
		ui_print "- Setting CPU Big Freq Governor to $GOVERNOR_BIG"
		insert_line sbin/kernelinit.sh "echo $GOVERNOR_BIG > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor" after "# Customisations" "echo $GOVERNOR_BIG > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor"
	fi

# Ramdisk changes for CPU Governors (Little)
	sed -i -- "s/governor-little=//g" /tmp/aroma/governor-little.prop
	GOVERNOR_LITTLE=`cat /tmp/aroma/governor-little.prop`
	if [[ "$GOVERNOR_LITTLE" != "interactive" ]]; then
		ui_print "- Setting CPU Little Freq Governor to $GOVERNOR_LITTLE"
		insert_line sbin/kernelinit.sh "echo $GOVERNOR_LITTLE > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" after "# Customisations" "echo $GOVERNOR_LITTLE > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
	fi

# Ramdisk changes for CPU Max Freq (Big)
	sed -i -- "s/cpumax-big=//g" /tmp/aroma/cpumax-big.prop;
	CPUMAX_BIG=`cat /tmp/aroma/cpumax-big.prop`
	if [[ "$CPUMAX_BIG" != "2288" ]]; then
		ui_print "- Setting CPU Big Max Freq to $CPUMAX_BIG Mhz"
		WORKVAL1=$CPUMAX_BIG$ZEROS
		insert_line sbin/kernelinit.sh "echo $WORKVAL1 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq" after "# Customisations" "echo $WORKVAL1 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq"
	fi

# Ramdisk changes for CPU Min Freq (Big)
	sed -i -- "s/cpumin-big=//g" /tmp/aroma/cpumin-big.prop;
	CPUMIN_BIG=`cat /tmp/aroma/cpumin-big.prop`;
	if [[ "$CPUMIN_BIG" != "208" ]]; then
		ui_print "- Setting CPU Big Min Freq to $CPUMIN_BIG Mhz"
		WORKVAL2=$CPUMIN_BIG$ZEROS
		insert_line sbin/kernelinit.sh "echo $WORKVAL2 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq" after "# Customisations" "echo $WORKVAL2 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq"
	fi

# Ramdisk changes for CPU Max Freq (Little)
	sed -i -- "s/cpumax-little=//g" /tmp/aroma/cpumax-little.prop;
	CPUMAX_LITTLE=`cat /tmp/aroma/cpumax-little.prop`
	if [[ "$CPUMAX_LITTLE" != "1586" ]]; then
		ui_print "- Setting CPU Little Max Freq to $CPUMAX_LITTLE Mhz";
		WORKVAL3=$CPUMAX_LITTLE$ZEROS
		insert_line sbin/kernelinit.sh "echo $WORKVAL3 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" after "# Customisations" "echo $WORKVAL3 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
	fi

# Ramdisk changes for CPU Min Freq (Little)
	sed -i -- "s/cpumin-little=//g" /tmp/aroma/cpumin-little.prop;
	CPUMIN_LITTLE=`cat /tmp/aroma/cpumin-little.prop`;
	if [[ "$CPUMIN_LITTLE" != "130" ]]; then
		ui_print "- Setting CPU Little Min Freq to $CPUMIN_LITTLE Mhz"
		WORKVAL4=$CPUMIN_LITTLE_ZEROS
		insert_line sbin/kernelinit.sh "echo $WORKVAL4 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" after "# Customisations" "echo $WORKVAL4 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq"
	fi

# Ramdisk changes for GPU Max Freq
	sed -i -- "s/gpumax=//g" /tmp/aroma/gpumax.prop;
	GPUMAX=`cat /tmp/aroma/gpumax.prop`
	if [[ "$GPUMAX" != "650" ]]; then
		ui_print "- Setting Max GPU Freq to $GPUMAX Mhz"
		insert_line sbin/kernelinit.sh "echo $GPUMAX > /sys/devices/14ac0000.mali/max_clock" after "# Customisations" "echo $GPUMAX > /sys/devices/14ac0000.mali/max_clock"
	fi

# Ramdisk changes for GPU Min Freq
	sed -i -- "s/gpumin=//g" /tmp/aroma/gpumin.prop
	GPUMIN=`cat /tmp/aroma/gpumin.prop`
	if [[ "$GPUMIN" != "260" ]]; then
		ui_print "- Setting Min  GPU Freq to $GPUMIN Mhz"
		insert_line sbin/kernelinit.sh "echo $GPUMIN > /sys/devices/14ac0000.mali/min_clock" after "# Customisations" "echo $GPUMIN > /sys/devices/14ac0000.mali/min_clock"
	fi

# Ramdisk changes for IO Schedulers (Internal)
	sed -i -- "s/scheduler-internal=//g" /tmp/aroma/scheduler-internal.prop
	SCHEDULER_INTERNAL=`cat /tmp/aroma/scheduler-internal.prop`
	if [[ "$SCHEDULER_INTERNAL" != "cfq" ]]; then
		ui_print "- Setting Internal IO Scheduler to $SCHEDULER_INTERNAL"
		insert_line sbin/kernelinit.sh "echo $SCHEDULER_INTERNAL > /sys/block/sda/queue/scheduler" after "# Customisations" "echo $SCHEDULER_INTERNAL > /sys/block/sda/queue/scheduler"
	fi

# Ramdisk changes for IO Schedulers (External)
	sed -i -- "s/scheduler-external=//g" /tmp/aroma/scheduler-external.prop
	SCHEDULER_EXTERNAL=`cat /tmp/aroma/scheduler-external.prop`
	if [[ "$SCHEDULER_EXTERNAL" != "cfq" ]]; then
		ui_print "- Setting External IO Scheduler to $SCHEDULER_EXTERNAL"
		insert_line sbin/kernelinit.sh "echo $SCHEDULER_EXTERNAL > /sys/block/mmcblk0/queue/scheduler" after "# Customisations" "echo $SCHEDULER_EXTERNAL > /sys/block/mmcblk0/queue/scheduler"
	fi

# Ramdisk changes for TCP Congestion Algorithms
	sed -i -- "s/tcp=//g" /tmp/aroma/tcp.prop
	TCP=`cat /tmp/aroma/tcp.prop`
	if [[ "$TCP" != "bic" ]]; then
		ui_print "- Setting TCP Congestion Algorithm to $TCP"
		insert_line sbin/kernelinit.sh "echo $TCP > /proc/sys/net/ipv4/tcp_congestion_control" after "# Customisations" "echo $TCP > /proc/sys/net/ipv4/tcp_congestion_control"
	fi

fi

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod 644 $ramdisk/default.prop
chmod 755 $ramdisk/init.rc
chmod 755 $ramdisk/sbin/kernelinit.sh
chown -R root:root $ramdisk/*

# End ramdisk changes
ui_print "- Writing Boot Image"
write_boot

## End install
ui_print "- Done"

