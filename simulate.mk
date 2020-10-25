EMMC := $(OUT)/simulated-emmc.img

simulate: $(OUT)/vice-embedded.img
	qemu-system-x86_64 \
		-bios /usr/share/qemu/OVMF.fd \
		-device usb-storage,drive=stick \
		-display gtk \
		-drive file=$(OUT)/vice-embedded.img,if=none,id=stick,format=raw \
		-enable-kvm \
		-m size=2048 \
		-machine q35 \
		-nodefaults \
		-usb \
		-vga virtio \

.PHONY:: simulate
