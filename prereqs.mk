PACKAGES := devscripts equivs fakeroot whalebuilder qemu-system-x86 ovmf

prereqs:
	sudo apt-get install $(PACKAGES)

.PHONY:: prereqs
