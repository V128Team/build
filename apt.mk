APT := $(OUT)/apt

$(APT):
	mkdir -p $(APT)
	cp `find $(OUT)/packages/* -maxdepth 1 -type f` $(APT)

$(OUT)/apt/Packages: $(APT)
	cd $(APT); apt-ftparchive packages . >Packages

apt: $(APT)/Packages

all:: apt

clean::
	rm -rf $(APT)

.PHONY:: apt
