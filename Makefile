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

include $(BUILD)/rootfs.mk
include $(BUILD)/release.mk

all::

clean::
	rmdir $(OUT)

.PHONY:: all clean

