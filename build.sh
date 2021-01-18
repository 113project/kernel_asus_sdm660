#!/bin/bash

export KERNELNAME=" 113 "

export LOCALVERSION=v1.1

export KBUILD_BUILD_USER=Kevin

export KBUILD_BUILD_HOST=DroneCI

export TOOLCHAIN=clang

export DEVICES=X00T

source helper

gen_toolchain

send_msg "Start building ${KERNELNAME} ${LOCALVERSION} for ${DEVICES}..."

START=$(date +"%s")

for i in ${DEVICES//,/ }
do
	build ${i} -HMP
done

send_msg "Building HMP version..."

git apply oc.patch

for i in ${DEVICES//,/ }
do
	if [ $i == "X00T" ]
	then
		build ${i} -OC
	fi
done

END=$(date +"%s")

DIFF=$(( END - START ))

send_msg "Build succesfully in $((DIFF / 60))m $((DIFF % 60))s"
