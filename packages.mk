$(OUT)/packages/Packages:
	apt-ftparchive packages $(OUT)/packages >$(OUT)/packages/Packages

packages: $(OUT)/packages/Packages

.PHONY:: packages
