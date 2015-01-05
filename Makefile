ARCHS = arm64 armv7

include theos/makefiles/common.mk

TWEAK_NAME = DefineCopy
DefineCopy_FILES = Tweak.xm
DefineCopy_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
