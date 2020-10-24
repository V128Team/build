EMMC := $(OUT)/simulated-emmc.img

$(EMMC):
	rm -f $(EMMC)
	dd if=/dev/zero of=$(EMMC) seek=32G

simulate: $(OUT)/vice-embedded.img $(EMMC)
	qemu-system-x86_64 \
		-enable-kvm \
		-m size=2048 \
		-bios /usr/share/qemu/OVMF.fd \
		-drive file=$(EMMC),if=ide,format=raw,unit=0 \
		-drive file=$(OUT)/vice-embedded.img,if=ide,format=raw,unit=1 \
		-display gtk

reset-hd:
	rm -f $(EMMC)

.PHONY:: simulate
