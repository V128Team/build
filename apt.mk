APT      := $(OUT)/apt

$(APT): $(BUILT_PACKAGES)
	mkdir -p $(APT)
	cp $(BUILT_PACKAGES) $(APT)
	touch $(APT)

$(APT)/Packages: $(APT)
	cd $(APT); apt-ftparchive packages . >Packages

apt: $(APT)/Packages

all:: apt

clean::
	rm -rf $(APT)

.PHONY:: apt
