$(OUT)/packages:
	mkdir -p $(OUT)/packages

$(OUT)/packagework:
	mkdir -p $(OUT)/packagework

include $(BUILD)/package_build.mk

$(eval $(call build_package,vice,amd64))
$(eval $(call build_package,plymouth-v128-theme,all))
$(eval $(call build_package,libwld,amd64))
$(eval $(call build_package,libswc,amd64,libwld))
#$(eval $(call build_package,v128-shell,amd64,libswc libwld))

clean::
	rm -rf $(OUT)/packages
	rm -rf $(OUT)/packagework
