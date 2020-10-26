$(OUT)/packages:
	mkdir -p $(OUT)/packages

$(OUT)/packagework:
	mkdir -p $(OUT)/packagework

include $(BUILD)/package_build.mk

$(eval $(call build_package,vice,amd64))
$(eval $(call build_package,plymouth-v128-theme,all))
$(eval $(call build_package,pywayland,amd64))
$(eval $(call build_package,pywlroots,amd64,pywayland))
$(eval $(call build_package,v128-shell,amd64,pywlroots pywayland))

clean::
	rm -rf $(OUT)/packages
	rm -rf $(OUT)/packagework
