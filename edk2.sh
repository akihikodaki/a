#!/bin/bash
# SPDX-License-Identifier: 0BSD

. edksetup.sh
make -C BaseTools/Source/C "-j$(nproc)"
build -a IA32 -a X64 -p UefiPayloadPkg/UefiPayloadPkg.dsc -b RELEASE -t GCC -D BOOTLOADER=COREBOOT
