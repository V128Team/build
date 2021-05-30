DEBIAN_DISTRO := testing

$(OUT)/debspawn:
	mkdir -p $(OUT)/debspawn

$(OUT)/debspawn/debspawn.json: $(ROOTDIR)/build/debspawn.json.in | $(OUT)/debspawn
	cat $(ROOTDIR)/build/debspawn.json.in |sed -e 's,@OUT@,$(OUT),g' > $(OUT)/packagework/debspawn.json
	cat $(OUT)/packagework/debspawn.json \
	    |sed 's/[,":]//g' \
	    |awk '/Dir/ { print $$2 }' \
        |xargs mkdir -p

$(OUT)/debspawn/roots/$(DEBIAN_DISTRO)-armhf.tar.zst: | $(OUT)/packagework $(OUT)/debspawn/debspawn.json
	debspawn \
	  -c $(OUT)/packagework/debspawn.json \
      create \
      --arch=armhf \
      $(DEBIAN_DISTRO)

define build_package
$(eval PACKAGE_NAME := $(1))
$(eval PACKAGE_ARCH := $(2))
$(eval PACKAGE_DEPS := $(3))

# Ensure we skip the "all" arch and force it to armhf
$(eval DEBSPAWN_ARCH := $(if $(filter all,$(PACKAGE_ARCH)),armhf,$(PACKAGE_ARCH)))

ifeq ($(PACKAGE_DEPS),)
$(eval WHALE_DEPS := )
else
$(eval WHALE_DEPS := $(foreach pkg,$(3),--deb $(wildcard $(OUT)/packages/$(pkg)*/$(pkg)_*.deb)))
endif

$(eval DEPS := )

$(eval SOURCES   := $(shell find $(ROOTDIR)/packages/$(PACKAGE_NAME) -type f))
$(eval CHANGELOG := $(ROOTDIR)/packages/$(PACKAGE_NAME)/debian/changelog)
$(eval PKGVER    := $(shell dpkg-parsechangelog -l $(CHANGELOG) -S Version))

$(eval WORKDIR := $(OUT)/packagework/$(PACKAGE_NAME)-$(PKGVER))
$(eval DSCFILE := $(OUT)/packagework/$(PACKAGE_NAME)_$(PKGVER).dsc)
$(eval PACKAGE := $(OUT)/packages/$(PACKAGE_NAME)_$(PKGVER)_$(PACKAGE_ARCH).deb)

$(eval PACKAGE_CONTAINER := $(OUT)/debspawn/roots/$(DEBIAN_DISTRO)-$(DEBSPAWN_ARCH).tar.zst)

$(WORKDIR): $(DEPS) $(SOURCES) | $(OUT)/packagework
	rm -rf $(WORKDIR)
	cp -r $(ROOTDIR)/packages/$(PACKAGE_NAME) $(WORKDIR)

$(DSCFILE): $(WORKDIR) $(SOURCES)
	cd $(WORKDIR) && dpkg-source -b .

$(PACKAGE): $(WORKDIR) $(DSCFILE) $(SOURCES) $(PACKAGE_CONTAINER) | $(OUT)/packages $(OUT)/debspawn/debspawn.json
	cd $(WORKDIR); \
      debspawn -c $(OUT)/packagework/debspawn.json \
      build \
      --buildflags="-J`nproc`" \
      --arch $(DEBSPAWN_ARCH) \
      --lintian \
      $(DEBIAN_DISTRO) $(DSCFILE)

$(PACKAGE_NAME): $(PACKAGE) $(SOURCES)

all-packages:: $(PACKAGE_NAME)

clean::
	rm -rf $(WORKDIR)
	rm -rf $(dir $(PACKAGE))

.PHONY:: vice clean all-packages $(PACKAGE_NAME)

BUILT_PACKAGES += $(PACKAGE)
endef
