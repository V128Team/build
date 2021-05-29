PACKAGES := devscripts equivs fakeroot qemu-system-x86 ovmf debspawn

prereqs:
	sudo apt-get install $(PACKAGES)

.PHONY:: prereqs
