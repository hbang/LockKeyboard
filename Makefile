include theos/makefiles/common.mk

TWEAK_NAME = LockKeyboard
LockKeyboard_FILES = Tweak.xm
LockKeyboard_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall MobileNotes"

after-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)
	$(ECHO_NOTHING)cp postrm $(THEOS_STAGING_DIR)/DEBIAN/postrm$(ECHO_END)
