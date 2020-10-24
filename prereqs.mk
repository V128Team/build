PACKAGES := devscripts equivs fakeroot whalebuilder

prereqs:
	sudo apt-get install $(PACKAGES)
	sudo mk-build-deps --install $(ROOTDIR)/packages/vice/debian/control
	whalebuilder create -r testing debian:testing

.PHONY:: prereqs
