ifeq ($(PLATFORM),udoo)
SIMULATOR := qemu-system-x86_64
endif

ifeq ($(SIMULATOR),)
$(error No simulator for platform [$(PLATFORM)])
endif

simulate:
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
		-device virtio-vga,virgl=on \
		-device usb-audio \
		-nic user,model=virtio-net-pci

mount:
	sudo kpartx -as $(OUT)/vice-embedded.img
	mkdir -p $(OUT)/mount
	sudo mount /dev/mapper/loop0p2 $(OUT)/mount

extract-logs: mount
	rm -rf $(OUT)/logs
	mkdir -p $(OUT)/logs
	rsync -r $(OUT)/mount/var/log/v128/* $(OUT)/logs
	sudo umount /dev/mapper/loop0p2
	sudo kpartx -ds $(OUT)/vice-embedded.img

umount: unmount
unmount:
	sudo umount /dev/mapper/loop0p2
	sudo kpartx -ds $(OUT)/vice-embedded.img

clean::
	rm -rf $(OUT)/mount
	rm -rf $(OUT)/logs

.PHONY:: simulate extract-logs mount unmount umount
