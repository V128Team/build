define build_package
$(eval PACKAGE_NAME := $(1))
$(eval PACKAGE_ARCH := $(2))

$(eval DEPS := $(BUILD)/package_build.mk)

$(eval SOURCES   := $(shell find $(ROOTDIR)/packages/$(PACKAGE_NAME) -type f))
$(eval CHANGELOG := $(ROOTDIR)/packages/$(PACKAGE_NAME)/debian/changelog)
$(eval PKGVER    := $(shell dpkg-parsechangelog -l $(CHANGELOG) -S Version))

$(eval WORKDIR := $(OUT)/packagework/$(PACKAGE_NAME)-$(PKGVER))
$(eval DSCFILE := $(OUT)/packagework/$(PACKAGE_NAME)_$(PKGVER).dsc)
$(eval PACKAGE := $(OUT)/packages/$(PACKAGE_NAME)_$(PKGVER)/$(PACKAGE_NAME)_$(PKGVER)_$(PACKAGE_ARCH).deb)

$(WORKDIR): $(DEPS) $(SOURCES) | $(OUT)/packagework
	rm -rf $(WORKDIR)
	cp -r $(ROOTDIR)/packages/$(PACKAGE_NAME) $(WORKDIR)

$(DSCFILE): $(WORKDIR) $(SOURCES)
	cd $(WORKDIR) && dpkg-buildpackage -us --build=source

$(PACKAGE): $(WORKDIR) $(DSCFILE) $(SOURCES) | $(OUT)/packages
	cd $(OUT)/packagework && whalebuilder build \
		--results $(OUT)/packages \
		whalebuilder/debian:testing \
		$(PACKAGE_NAME)_$(PKGVER).dsc -- -tc -us -j$(shell nproc)
	rm -rf $(OUT)/apt

$(PACKAGE_NAME): $(PACKAGE) $(SOURCES)

all-packages:: $(PACKAGE_NAME)

clean::
	rm -rf $(WORKDIR)
	rm -rf $(dir $(PACKAGE))

.PHONY:: vice clean all-packages $(PACKAGE_NAME)

BUILT_PACKAGES += $(PACKAGE)
endef
