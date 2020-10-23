ROOTDIR      := $(patsubst %/build/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
BUILD        := $(ROOTDIR)/build
OUT          := $(ROOTDIR)/out
$(warning ROOTDIR = [$(ROOTDIR)])
$(warning OUT     = [$(OUT)])
$(warning )

BUILDSCRIPTS := $(shell find $(ROOTDIR)/build -type f)

$(OUT):
	mkdir -p $(OUT)

include $(BUILD)/rootfs.mk

all::

clean::
	rmdir $(OUT)

.PHONY:: all clean
