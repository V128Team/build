APT      := $(OUT)/apt
BUILT_PACKAGES := $(shell find $(OUT)/packages/* -maxdepth 1 -type f)

$(APT): $(BUILT_PACKAGES)
	mkdir -p $(APT)
	cp $(BUILT_PACKAGES) $(APT)
	touch $(APT)

$(OUT)/apt/Packages: $(APT)
	cd $(APT); apt-ftparchive packages . >Packages

apt: $(APT)/Packages

all:: apt

clean::
	rm -rf $(APT)

.PHONY:: apt
