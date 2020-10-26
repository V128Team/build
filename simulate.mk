EMMC := $(OUT)/simulated-emmc.img

simulate:
	qemu-system-x86_64 \
		-bios /usr/share/qemu/OVMF.fd \
		-device usb-storage,drive=stick \
		-display gtk,gl=on \
		-drive file=$(OUT)/vice-embedded.img,if=none,id=stick,format=raw \
		-enable-kvm \
		-m size=2048 \
		-machine q35 \
		-nodefaults \
		-usb \
		-device virtio-vga,virgl=on

.PHONY:: simulate
