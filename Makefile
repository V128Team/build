ROOTDIR      := $(patsubst %/build/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
BUILD        := $(ROOTDIR)/build
OUT          := $(ROOTDIR)/out

$(warning ==================================================)
$(warning ROOTDIR = [$(ROOTDIR)])
$(warning BUILD   = [$(BUILD)])
$(warning OUT     = [$(OUT)])
$(warning ==================================================)

BUILDSCRIPTS := $(shell find $(ROOTDIR)/build -type f)

.DEFAULT_GOAL := all

$(OUT):
	mkdir -p $(OUT)

# Packages here first
include $(BUILD)/vice.mk

# Build the rootfs
include $(BUILD)/apt.mk
include $(BUILD)/rootfs.mk

# Seldom used targets, but necessary for the build
include $(BUILD)/release.mk
include $(BUILD)/prereqs.mk
include $(BUILD)/simulate.mk

all::
	@echo ==================================================
	@echo
	@echo Build complete!
	@echo

clean::
	rmdir $(OUT)

.PHONY:: all clean
