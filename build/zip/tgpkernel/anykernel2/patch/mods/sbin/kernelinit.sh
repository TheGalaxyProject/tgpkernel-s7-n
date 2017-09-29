#!/system/bin/sh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Created by @djb77. Code snippets from @Tkkg1994, @Morogoku, and @Chainfire.
#

# Set Variables
BB=/sbin/busybox;

# Mount
$BB mount -t rootfs -o remount,rw rootfs;
$BB mount -o remount,rw /system;
$BB mount -o remount,rw /data;
$BB mount -o remount,rw /;

# Set KNOX to 0x0 on running /system
/sbin/resetprop -v -n ro.boot.warranty_bit "0"
/sbin/resetprop -v -n ro.warranty_bit "0"

# Fix Safetynet flags
/sbin/resetprop -v -n ro.boot.veritymode "enforcing"
/sbin/resetprop -v -n ro.boot.verifiedbootstate "green"
/sbin/resetprop -v -n ro.boot.flash.locked "1"
/sbin/resetprop -v -n ro.boot.ddrinfo "00000001"

# Fix Samsung Related Flags
/sbin/resetprop -v -n ro.fmp_config "1"
/sbin/resetprop -v -n ro.boot.fmp_config "1"
/sbin/resetprop -v -n sys.oem_unlock_allowed "0"

# Deepsleep fix
for i in `ls /sys/class/scsi_disk/`; do
	cat /sys/class/scsi_disk/$i/write_protect 2>/dev/null | grep 1 >/dev/null
	if [ $? -eq 0 ]; then
		echo 'temporary none' > /sys/class/scsi_disk/$i/cache_type
	fi
done

# SELinux Permissive / Enforcing Patch
# 0 = Permissive, 1 = Enforcing
chmod 644 /sys/fs/selinux/enforce
setenforce 0
chmod 640 /sys/fs/selinux/enforce

# PWMFix
# 0 = Disabled, 1 = Enabled
echo "0" > /sys/class/lcd/panel/smart_on

# Stock CPU / GPU Settings
echo "2288000" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
echo "208000" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo "1586000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "130000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo "650" > /sys/devices/14ac0000.mali/max_clock
echo "260" > /sys/devices/14ac0000.mali/min_clock

# Tweaks: SD-Card Readhead
echo "2048" > /sys/devices/virtual/bdi/179:0/read_ahead_kb;

# Tweaks: Internet Speed
echo "0" > /proc/sys/net/ipv4/tcp_timestamps;
echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse;
echo "1" > /proc/sys/net/ipv4/tcp_sack;
echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle;
echo "1" > /proc/sys/net/ipv4/tcp_window_scaling;
echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes;
echo "30" > /proc/sys/net/ipv4/tcp_keepalive_intvl;
echo "30" > /proc/sys/net/ipv4/tcp_fin_timeout;
echo "404480" > /proc/sys/net/core/wmem_max;
echo "404480" > /proc/sys/net/core/rmem_max;
echo "256960" > /proc/sys/net/core/rmem_default;
echo "256960" > /proc/sys/net/core/wmem_default;
echo "4096,16384,404480" > /proc/sys/net/ipv4/tcp_wmem;
echo "4096,87380,404480" > /proc/sys/net/ipv4/tcp_rmem;

# Customisations


# Unmount
$BB mount -t rootfs -o remount,ro rootfs;
$BB mount -o remount,ro /system;
$BB mount -o remount,rw /data;
$BB mount -o remount,ro /;
