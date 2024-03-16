import os

Ndisk = '' #sdb
linux = '/dev/' + Ndisk

def write():
    disk = open(f'{linux}', 'rb+')
    data = disk.read(512)
    disk.seek(0)
    bin = open('floppy_Bird.bin', 'rb')
    safe = open('Safedata.bin', 'wb+')
    safe.write(data)
    flappy = bin.read(446)
    disk.write(flappy)
    disk.flush()
    os.fsync(disk.fileno())
    disk.close()
    bin.close()
    safe.close()

def write_2():
    disk = open(f'{linux}', 'rb+')
    disk.seek(0)
    bin = open('floppy_Bird.bin', 'rb')
    flappy = bin.read(446)
    disk.write(flappy)
    disk.flush()
    os.fsync(disk.fileno())
    disk.close()
    bin.close()


def recovery():
    disk = open(f'/dev/{linux}', 'rb+')
    safe = open('Safedata.bin', 'rb')
    data = safe.read(512)
    disk.write(data)
    disk.close()
    safe.close()


n = int(input())

if n == 0:
    write()
elif n == 1: 
    write_2()
elif n == 2:
    recovery()