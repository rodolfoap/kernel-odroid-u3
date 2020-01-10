# kernel-odroid-u3
Tools to build an Odroid-U3 kernel

All the merit to _hexdump_, https://github.com/hexdump0815 !

## Usage

* Cross-build the kernel on an external machine (do not hesitate to fork and fix issues, the apt command was run on a dirty fs, some dependencies might be missing):

```
./build
```
* Make a backup of your Odroid-U3 card.
* Install some distro on the Odroid-U3, e.g. https://github.com/hexdump0815/imagebuilder/releases/tag/190924-01
* Copy the result to the install root, unpack it, run the following commands and reboot:

```
chown -R root: /boot
cd /boot/dtb-5.4.5-stb-exy+/
cat /README.odroid-u3
update-initramfs -c -k 5.4.5-stb-exy+
mkimage -A arm -O linux -T ramdisk -a 0x0 -e 0x0 -n initrd.img-5.4.5-stb-exy+ -d initrd.img-5.4.5-stb-exy+ uInitrd-5.4.5-stb-exy+

```

* Check that **/boot/extlinux/extlinux.conf** has...
```
DEFAULT v5450
...
LABEL v5450
      MENU LABEL v5.4.5 mali kernel mmcblk0
      LINUX ../zImage-5.4.5-stb-exy+
      FDT ../dtb-5.4.5-stb-exy+/exynos4412-odroidu3.dtb
      APPEND console=ttySAC1,115200n8 console=tty1 mem=2047M smsc95xx.macaddr=ba:5d:6d:41:68:6f root=PARTUUID=304ee0c7-03 ro loglevel=8 rootwait net.ifnames=0 ipv6.disable=1 fsck.repair=yes video=HDMI-A-1:e drm.edid_firmware=edid/1024x768.bin
```

_(tested on Odroid-U3, kver==5.4.5-stb-exy+)_

## Cryptsetup issues

In my case, _cryptsetup_ is required for some mounts (not root), but _cryptsetup-initramfs_ cannot be uninstalled without uninstalling _cryptsetup_, so this happens:

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
The solution is to run this before _update-initramfs_ (make a previous backup!):

```
sed -i 's/^#*CRYPTSETUP=.*/CRYPTSETUP=n/' /etc/cryptsetup-initramfs/conf-hook
```

## Output

```
lib/modules/5.4.5-stb-exy+/kernel/sound/drivers/snd-aloop.ko
lib/modules/5.4.5-stb-exy+/kernel/kernel/
lib/modules/5.4.5-stb-exy+/kernel/kernel/configs.ko
lib/modules/5.4.5-stb-exy+/modules.builtin
lib/modules/5.4.5-stb-exy+/modules.alias.bin
lib/modules/5.4.5-stb-exy+/modules.devname
lib/modules/5.4.5-stb-exy+/modules.dep.bin
lib/modules/5.4.5-stb-exy+/modules.symbols
+ popd
~/git/kernel-odroid-u3
+ tree -L 5 rootfs/
rootfs/
├── boot
│   ├── config-
│   ├── config-5.4.5-stb-exy+
│   ├── dtb-
│   ├── dtb-5.4.5-stb-exy+
│   │   ├── exynos4412-odroidu3.dtb
│   │   └── exynos4412-odroidx2.dtb
│   ├── System.map-5.4.5-stb-exy+
│   └── zImage-5.4.5-stb-exy+
├── lib
│   └── modules
│       └── 5.4.5-stb-exy+
│           ├── kernel
│           │   ├── arch
│           │   ├── crypto
│           │   ├── drivers
│           │   ├── fs
│           │   ├── kernel
│           │   ├── lib
│           │   ├── net
│           │   └── sound
│           ├── modules.alias
│           ├── modules.alias.bin
│           ├── modules.builtin
│           ├── modules.builtin.bin
│           ├── modules.builtin.modinfo
│           ├── modules.dep
│           ├── modules.dep.bin
│           ├── modules.devname
│           ├── modules.order
│           ├── modules.softdep
│           ├── modules.symbols
│           └── modules.symbols.bin
└── README.odroid-u3

```

## Disclaimer

Use it at your own risk. This is intended to be done by someone with the proper knowledge. And the proper backup.

* https://forum.odroid.com/viewtopic.php?f=55&t=3691&start=400#p267864
