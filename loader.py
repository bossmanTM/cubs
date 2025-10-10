with open("loader.bin", 'r+b') as bootFile:
    boot = bytearray(bootFile.read())
    bootFile.seek(90)
    with open("stage1/boot.bin", 'rb') as loader:
        boot = loader.read()
        bootFile.write(boot)
