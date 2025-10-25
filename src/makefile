.PHONY: stage1 stage2

ASFLAGS := -i $(dir $(abspath lib))../lib
export ASFLAGS

run: loader
	qemu-system-x86_64 -drive format=raw,file=loader.img

loader.img:	
	truncate -s 64M loader.img
	mkfs.fat -F 32 loader.img

loader: stage1 loader.img stage2
	python3 loader.py

stage2: loader.img
	$(MAKE) -C $@ all
	$(eval TMP := $(shell mktemp -d))
	sudo mount loader.img $(TMP)
	sudo cp -u stage2/boot.bin $(TMP)/BOOT.BIN
	sync
	sudo umount $(TMP)
	rm -rf $(TMP)

stage1:
	$(MAKE) -C $@ all
