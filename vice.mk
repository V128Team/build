DEPS    := $(BUILD)/vice.mk
SOURCES := $(shell find $(ROOTDIR)/packages/vice -type f)

CHANGELOG := $(ROOTDIR)/packages/vice/debian/changelog
PKGVER    := $(shell dpkg-parsechangelog -l $(CHANGELOG) -S Version)
VICEVER   := $(shell echo $(PKGVER) |sed 's/\.v128-.*$$//')

WORKDIR := $(OUT)/packagework/vice-$(PKGVER)
DSCFILE := $(OUT)/packagework/vice_$(PKGVER).dsc
PACKAGE := $(OUT)/packages/vice-$(PKGVER).deb
DESTDIR := $(OUT)/packages

$(WORKDIR): $(SOURCES)
	mkdir -p $(OUT)/packagework
	cp -r $(ROOTDIR)/packages/vice $(WORKDIR)

$(DESTDIR):
	mkdir -p $(DESTDIR)

$(DSCFILE): $(WORKDIR)
	cd $(WORKDIR) && dpkg-buildpackage -us --build=source

$(PACKAGE): $(WORKDIR) $(DSCFILE) | $(DESTDIR)
	cd $(OUT)/packagework && whalebuilder build \
		--results $(DESTDIR) \
		whalebuilder/debian:testing \
		vice_$(PKGVER).dsc -- -tc -us -j$(shell nproc)

vice: $(PACKAGE)

all:: vice

clean::
	rm -rf $(WORKDIR)
	rm -rf $(OUT)/packages
	rm -rf $(OUT)/packagework

.PHONY:: vice
