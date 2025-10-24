.PHONY: stage1 stage2

run: loader
	qemu-system-x86_64 loader.bin

loader: stage1
	truncate -s 64M loader.bin
	python3 loader.py

stage*:
	$(MAKE) -C $@ boot
