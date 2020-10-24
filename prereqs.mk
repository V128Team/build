PACKAGES := devscripts equivs fakeroot whalebuilder

prereqs:
	sudo apt-get install $(PACKAGES)

.PHONY:: prereqs
