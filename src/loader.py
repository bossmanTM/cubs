with open("loader.bin", 'r+b') as bootFile:
    boot = bytearray(bootFile.read())
    bootFile.seek(0x5a)
    with open("stage1/boot.bin", 'rb') as loader:
        boot = loader.read()
        bootFile.write(boot)
        bootFile.seek(0xc5a)
        bootFile.write(boot)
