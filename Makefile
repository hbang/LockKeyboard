include theos/makefiles/common.mk

TWEAK_NAME = LockKeyboard
LockKeyboard_FILES = Tweak.xm
LockKeyboard_PRIVATE_FRAMEWORKS = SpringBoardUI

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall MobileNotes"
