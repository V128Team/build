RELEASE_FILES := \
	$(ROOTDIR)/distro/README.txt \
	$(OUT)/vice-embedded.img

DEPS := \
	$(BUILD)/rootfs.mk \
	$(BUILD)/release.mk

DATESTAMP := $(shell date +%Y%m%d)
RELEASE_ROOT := vice-embedded-$(DATESTAMP)
RELEASEDIR := $(OUT)/$(RELEASE_ROOT)

ZIP := $(shell which zip)
TAR := $(shell which tar)
BZIP2 := $(shell which bzip2)

ifeq ($(ZIP)$(TAR)$(BZIP2),)
$(error zip, tar, or bzip2 could not be found. Please reinstall them and try again)
endif

$(RELEASEDIR): $(RELEASE_FILES) $(DEPS)
	mkdir -p $(RELEASEDIR)
	cp $(RELEASE_FILES) $(RELEASEDIR)

$(RELEASEDIR)/commits.txt:
	repo forall -c 'git log -n1 --pretty=format:"$$REPO_PROJECT %H"; echo' >$(RELEASEDIR)/commits.txt

$(OUT)/$(RELEASE_ROOT).zip: $(RELEASEDIR) $(RELEASEDIR)/commits.txt
	cd $(OUT); zip -9r $(RELEASE_ROOT).zip $(notdir $(RELEASEDIR))

$(OUT)/$(RELEASE_ROOT).tar.bz2: $(RELEASEDIR) $(RELEASEDIR)/commits.txt
	tar -C $(OUT) -jcf $(OUT)/$(RELEASE_ROOT).tar.bz2 $(notdir $(RELEASEDIR))

$(OUT)/$(RELEASE_ROOT)%.sha256: $(OUT)/$(RELEASE_ROOT)%
	sha256sum $< > $@

release: $(OUT)/$(RELEASE_ROOT).zip.sha256 $(OUT)/$(RELEASE_ROOT).tar.bz2.sha256

clean::
	rm -rf $(OUT)/vice-embedded-*

.PHONY:: release
