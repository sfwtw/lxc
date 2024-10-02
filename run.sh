#!/bin/bash
cd $(dirname $0)

DIR=$(pwd)
LLVM_DIR=$DIR/prebuilts-master/clang/host/linux-x86/clang-r416183b/bin
export CROSS_COMPILE=$LLVM_DIR/aarch64-linux-gnu-
export CC=$LLVM_DIR/clang
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s
export PATH=$LLVM_DIR:$PATH
export TARGET_SOC=waipio
export LLVM=1 LLVM_IAS=1 LTO="thin"
export ARCH=arm64
export LOCALVERSION="-yun"

make clean; rm -rf out; mkdir out
make -j$(nproc) -C $DIR O=$DIR/out cs_defconfig
./scripts/config --file out/.config \
    -d UH -d RKP -d KDP -d SECURITY_DEFEX -d INTEGRITY -d FIVE -d TRIM_UNUSED_KSYMS \ 
    -e LTO_CLANG_THIN -e SYSVIPC -e POSIX_MQUEUE -e CGROUP_DEVICE -e PID_NS -e USER_NS \
    -e BT_HCIVHCI -e NETFILTER_XT_TARGET_CHECKSUM -e NETFILTER_XT_MATCH_ADDRTYPE \
    -e IP6_NF_TARGET_MASQUERADE -e DEVTMPFS -e NULL_TTY -e BRIDGE_NETFILTER -e VT \
    -e NETFILTER_XT_MATCH_IPVS -e IP_VS -e CONFIG_IP6_NF_NAT -d MODULE_SCMVERSION
make -j$(nproc) -C $DIR O=$DIR/out