DEPS    := $(BUILD)/rootfs.mk
SOURCES := $(shell find $(ROOTDIR)/distro -type f)
DEBOS   := $(shell which debos)
IMAGE   := $(OUT)/vice-embedded.img

ifeq ($(DEBOS),)
$(error The debos tool could not be found -- please install and try again)
endif

$(OUT)/debos: $(SOURCES) $(BUILD_PACKAGES) $(OUT)/apt/Packages
	mkdir -p $(OUT)/debos
	cp -r $(ROOTDIR)/distro/* $(OUT)/debos/
	cp -r $(OUT)/apt $(OUT)/debos/apt
	touch $(OUT)/debos

$(IMAGE): $(DEPS) $(SOURCES) $(OUT)/apt/Packages $(OUT)/debos | $(OUT) cleanimage
	rm -f $(IMAGE)
	cd $(OUT)/debos && $(DEBOS) \
		--debug-shell \
		--show-boot \
		--verbose \
		--memory=4096MB \
		-t image:$(IMAGE) \
		--artifactdir=$(OUT)/debos \
		$(OUT)/debos/vice-embedded-pi.yaml

all:: rootfs

cleanimage:
	rm -f $(IMAGE)

rootfs: $(IMAGE) | cleanimage

clean::
	rm -rf $(IMAGE) $(OUT)/vice-embedded.* $(OUT)/debos

.PHONY:: rootfs cleanimage
