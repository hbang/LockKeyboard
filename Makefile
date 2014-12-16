include theos/makefiles/common.mk

TWEAK_NAME = LockKeyboard
LockKeyboard_FILES = Tweak.xm
LockKeyboard_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall MobileNotes; sleep 0.2; sblaunch com.apple.mobilenotes"
