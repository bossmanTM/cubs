.PHONY: stage1 stage2

run: loader
	qemu-system-x86_64 -drive format=raw,file=loader.bin

loader: stage1 stage2
	truncate -s 64M loader.bin
	python3 loader.py

stage*:
	$(MAKE) -C $@ boot
