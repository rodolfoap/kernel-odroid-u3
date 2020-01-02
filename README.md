# kernel-odroid-u3
Tools to build an Odroid-U3 kernel

# Usage

* Build the kernel (do not hesitate to fork and fix issues, the apt command was run on a dirty fs, some dependencies might be missing):

```
./build
```

* Install some distro on the Odroid-U3, e.g. https://github.com/hexdump0815/imagebuilder/releases/tag/190924-01
* Copy the result to the install root, unpack it, run the following commands and reboot.

```
chown -R root: /boot
cd /boot/dtb-5.4.5-stb-exy+/
update-initramfs -c -k 5.4.5-stb-exy+
mkimage -A arm -O linux -T ramdisk -a 0x0 -e 0x0 -n initrd.img-5.4.5-stb-exy+ -d initrd.img-5.4.5-stb-exy+ uInitrd-5.4.5-stb-exy+

```
(tested on Odroid-U3, kver==5.4.5-stb-exy+)

All the merit to _hexdump_, https://github.com/hexdump0815 !
