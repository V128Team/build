DEPS    := $(BUILDSCRIPTS)
SOURCES := $(shell find $(ROOTDIR)/distro -type f)
DEBOS   := $(shell which debos)
IMAGE   := $(OUT)/vice-embedded.img

ifeq ($(DEBOS),)
$(error The debos tool could not be found -- please install and try again)
endif

$(OUT)/debos-artifacts:
	mkdir -p $(OUT)/debos-artifacts

$(IMAGE): $(SOURCES) $(DEPS) | $(OUT) $(OUT)/debos-artifacts
	$(DEBOS) \
		-t image:$(IMAGE) \
		--artifactdir=$(OUT)/debos-artifacts \
		distro/vice-embedded.yaml

all:: rootfs

rootfs: $(IMAGE)

clean::
	rm -rf $(IMAGE) $(OUT)/vice-embedded.* $(OUT)/debos-artifacts

.PHONY:: rootfs
.DELETE_ON_ERROR:: $(IMAGE)
