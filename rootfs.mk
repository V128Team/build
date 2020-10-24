DEPS    := $(BUILD)/rootfs.mk $(BUILD)/Makefile
SOURCES := $(shell find $(ROOTDIR)/distro -type f)
DEBOS   := $(shell which debos)
IMAGE   := $(OUT)/vice-embedded.img

ifeq ($(DEBOS),)
$(error The debos tool could not be found -- please install and try again)
endif

$(OUT)/debos: $(SOURCES)
	mkdir -p $(OUT)/debos
	cp -r $(ROOTDIR)/distro/* $(OUT)/debos/
	cp -r $(OUT)/apt $(OUT)/debos/apt

$(IMAGE): $(DEPS) | $(OUT) $(OUT)/debos
	cd $(OUT)/debos && $(DEBOS) \
		-t image:$(IMAGE) \
		--artifactdir=$(OUT)/debos \
		$(OUT)/debos/vice-embedded.yaml

all:: rootfs

rootfs: $(IMAGE)

clean::
	rm -rf $(IMAGE) $(OUT)/vice-embedded.* $(OUT)/debos

.PHONY:: rootfs
