#!/bin/bash

# shitty kernel reeeee

#DEVICENAME=daisy

echo $DEVICENAME | egrep "daikura|daisy|sakura|ysl" || (echo not testes && exit)

#if ! [ -f arch/arm64/configs/xiaomi/"$DEVICENAME".config ]; then
#  echo arch/arm64/configs/xiaomi/"$DEVICENAME".config doesnt exist
#  exit
#fi



#PREFIX="$(pwd)"
PREFIX="/tmp/tc"
GCC64="gcc-arm64-gcc-master"
GCC32="gcc-arm-gcc-master"
CLANG="greenforce"

export PATH=""$(pwd)"${GCC64}/bin:$PATH"
export ARCH=arm64
export SUBARCH=arm64
export HEADER_ARCH=arm64

# Garbage removal

#rm -rf out
#mkdir out
#rm -rf error.log
#make O=out clean 
#make mrproper


# Build

GCC64_DIR=${PREFIX}/${GCC64}
GCC32_DIR=${PREFIX}/${GCC32}
CLANG_DIR=${PREFIX}/${CLANG}

#gonna use ld.lld from clang disable the ones on evagcc
#chmod 000 $GCC64_DIR/bin/ld.lld
#chmod 000 $GCC32_DIR/bin/ld.lld
#gnu ld werks nao

export PATH="$GCC64_DIR/bin:$GCC32_DIR/bin:$CLANG_DIR/bin:$PATH"

#echo $PATH

mkdir "out_$DEVICENAME"

if [ "$DEVICENAME" == "daikura" ]; then 
ARCH=arm64 scripts/kconfig/merge_config.sh -O "out_$DEVICENAME" arch/arm64/configs/msm8953-perf_defconfig arch/arm64/configs/xiaomi/xiaomi.config arch/arm64/configs/xiaomi/sakura.config arch/arm64/configs/xiaomi/daisy.config lineageos_xx_append
elif [ "$DEVICENAME" != "daikura" ]; then
	if ! [ -f arch/arm64/configs/xiaomi/"$DEVICENAME".config ]; then
  	echo arch/arm64/configs/xiaomi/"$DEVICENAME".config doesnt exist
  	exit
	fi
ARCH=arm64 scripts/kconfig/merge_config.sh -O "out_$DEVICENAME" arch/arm64/configs/msm8953-perf_defconfig arch/arm64/configs/xiaomi/xiaomi.config arch/arm64/configs/xiaomi/"$DEVICENAME".config lineageos_xx_append
fi

make -j24 ARCH=arm64 SUBARCH=arm64 O="out_$DEVICENAME" \
        CROSS_COMPILE="ccache aarch64-elf-" \
        CROSS_COMPILE_ARM32="ccache arm-eabi-" \
        INSTALL_MOD_STRIP=1 \
	KBUILD_BUILD_USER="$(git rev-parse --short HEAD | cut -c1-7)" \
	KBUILD_BUILD_HOST="$(git symbolic-ref --short HEAD)" \
	KBUILD_BUILD_FEATURES="ksu: $(cd KernelSU/;expr 10000 + $(git rev-list --count HEAD) + 200) +umount / cpu: 2208MHz 990mV / gpu: 725MHz / ddr: 1066MHz / mods: adrenoboost anxiety bbr+ bore-sched kcal le9 lz4d-asm pltopt pewq SBalance wl_blocker zzmoove zram_entropy //"


# fp asimd evtstrm aes pmull sha1 sha2 crc32
# for i in $(ls patches/) ; do patch -Np1 < patches/$i ; done
