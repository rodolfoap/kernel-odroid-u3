# kernel-odroid-u3
Tools to build an Odroid-U3 kernel

All the merit to _hexdump_, https://github.com/hexdump0815 !

## Usage

* Build the kernel (do not hesitate to fork and fix issues, the apt command was run on a dirty fs, some dependencies might be missing):

```
./build
```

* Install some distro on the Odroid-U3, e.g. https://github.com/hexdump0815/imagebuilder/releases/tag/190924-01
* Copy the result to the install root, unpack it, run the following commands and reboot

```
chown -R root: /boot
cd /boot/dtb-5.4.5-stb-exy+/
cat /README.odroid-u3
update-initramfs -c -k 5.4.5-stb-exy+
mkimage -A arm -O linux -T ramdisk -a 0x0 -e 0x0 -n initrd.img-5.4.5-stb-exy+ -d initrd.img-5.4.5-stb-exy+ uInitrd-5.4.5-stb-exy+

```
(tested on Odroid-U3, kver==5.4.5-stb-exy+)

## Cryptsetup issues

In my case, _cryptsetup_ is required for some mounts (not root), so this happens:

```
# update-initramfs -c -k 5.4.5-stb-exy+
update-initramfs: Generating /boot/initrd.img-5.4.5-stb-exy+
cryptsetup: ERROR: Couldn't resolve device /dev/root
cryptsetup: WARNING: Couldn't determine root device
cryptsetup: WARNING: The initramfs image may not contain cryptsetup binaries 
    nor crypto modules. If that's on purpose, you may want to uninstall the 
    'cryptsetup-initramfs' package in order to disable the cryptsetup initramfs 
    integration and avoid this warning.
I: The initramfs will attempt to resume from /dev/mmcblk0p2
I: (UUID=7a6152ad-da23-4e20-8447-3efdba0d56ab)
I: Set the RESUME variable to override this.

```
The solution is to run this before _update-initramfs_:

```
sed -i 's/^#*CRYPTSETUP=.*/CRYPTSETUP=n/' /etc/cryptsetup-initramfs/conf-hook
```

## Disclaimer

Use it at your own risk. This is intended to be done by someone with the proper knowledge. And the proper backup.
