# SPDX-License-Identifier: 0BSD

.DELETE_ON_ERROR:

obj/bios.bin: coreboot/build/cbfstool altfw.txt edk2/Build/UefiPayloadPkgX64/RELEASE_GCC/FV/UEFIPAYLOAD.fd obj/original.bin
	cp obj/original.bin $@
	$< $@ remove -r RW_LEGACY -n altfw/list
	$< $@ remove -r RW_LEGACY -n cros_allow_auto_update
	$< $@ add-payload -r RW_LEGACY -c lzma -n altfw/a -f edk2/Build/UefiPayloadPkgX64/RELEASE_GCC/FV/UEFIPAYLOAD.fd
	$< $@ add -r RW_LEGACY -n altfw/list -f altfw.txt -t raw

obj/original.bin: flashrom/builddir/flashrom | obj
	$< -p host -r $@

coreboot/%:
	$(MAKE) -C coreboot $*

edk2/Build/UefiPayloadPkgX64/RELEASE_GCC/FV/UEFIPAYLOAD.fd: edk2.sh
	podman run --rm -it -v .:/a:Z -w /a/edk2 ghcr.io/tianocore/containers/fedora-37-build:a0dd931 ../$<

flashrom/builddir/flashrom: | flashrom/builddir
	meson compile -C flashrom/builddir

flashrom/builddir:
	meson setup $@ $(@D)

obj:
	mkdir $@
