EMMC := $(OUT)/simulated-emmc.img

$(EMMC):
	rm -f $(EMMC)
	dd if=/dev/zero of=$(EMMC) seek=32G

simulate: $(OUT)/vice-embedded.img $(EMMC)
	qemu-system-x86_64 \
		-nodefaults \
		-enable-kvm \
		-m size=2048 \
		-bios /usr/share/qemu/OVMF.fd \
		-usb \
		-drive file=$(OUT)/vice-embedded.img,if=none,id=stick,format=raw \
		-device usb-storage,drive=stick \
		-drive file=$(EMMC),if=ide,format=raw \
		-vga virtio \
		-display gtk

reset-hd:
	rm -f $(EMMC)

.PHONY:: simulate
