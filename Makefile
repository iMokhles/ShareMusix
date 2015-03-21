GO_EASY_ON_ME = 1
#TARGET_CODESIGN_FLAGS ="-Sentitlements.plist"
export SDKVERSION=8.1
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0
ADDITIONAL_CFLAGS = -fobjc-arc

export MODULES=nahm8

include theos/makefiles/common.mk

TWEAK_NAME = ShareMusix
ShareMusix_FILES = Tweak.xm $(wildcard *.m)
ShareMusix_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore CoreImage Accelerate AVFoundation AudioToolbox MobileCoreServices Social Accounts AssetsLibrary AdSupport MediaPlayer SystemConfiguration Security CoreText
ShareMusix_PRIVATE_FRAMEWORKS = MediaPlayer MediaPlayerUI MusicUI MusicCarDisplayUI

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
