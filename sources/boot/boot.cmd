setenv bootargs console=ttyS0,115200 noinitrd root=/dev/mmcblk0p2 rootfstype=ext3 rootwait panic=10 ${extra}
fatload mmc 0 0x43000000 script.bin
fatload mmc 0 0x48000000 uImage
bootm 0x48000000
