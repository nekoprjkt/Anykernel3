# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=NekoLite
kernel.compiler=Aosp Clang 11.0.5
message.word=AnyKernel3
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=ysl
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=auto;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

mount -o remount,rw /vendor

# Check if the script is present if so nuke it
sed -i '/revvz_exec/d' /vendor/bin/init.qcom.sh
sed -i '/revvz_exec/d' /vendor/bin/init.qcom.post_boot.sh
sed -i '/sleepy_exec.sh/d' /vendor/bin/init.qcom.sh
sed -i '/sleepy_exec.sh/d' /vendor/bin/init.qcom.post_boot.sh
rm -rf /vendor/bin/revvz_exec.sh
rm -rf /vendor/bin/sleepy_exec.sh

## AnyKernel boot install
dump_boot;

write_boot;
## end boot install


# shell variables
#block=vendor_boot;
#is_slot_device=1;
#ramdisk_compression=auto;
#patch_vbmeta_flag=auto;

# reset for vendor_boot patching
#reset_ak;


## AnyKernel vendor_boot install
#split_boot; # skip unpack/repack ramdisk since we don't need vendor_ramdisk access

#flash_boot;
## end vendor_boot install
