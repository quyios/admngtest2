ARCHS = arm64
TARGET = iphone:clang:latest:13.0

INSTALL_TARGET_PROCESSES = XXTExplorer

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = XXTHavocSpoof

XXTHavocSpoof_FILES = Tweak.xm
XXTHavocSpoof_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
