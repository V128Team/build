$(OUT)/packages:
	mkdir -p $(OUT)/packages

$(OUT)/packagework:
	mkdir -p $(OUT)/packagework

include $(BUILD)/package_build.mk

$(eval $(call build_package,vice,armhf))
$(eval $(call build_package,plymouth-v128-theme,all))
$(eval $(call build_package,v128-shell,armhf))
$(eval $(call build_package,pi4-firmware,all))
$(eval $(call build_package,rpi-eeprom,all))
$(eval $(call build_package,mdt-services,all))

clean::
	rm -rf $(OUT)/packages
	rm -rf $(OUT)/packagework
