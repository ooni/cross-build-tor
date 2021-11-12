PLATFORM := iphoneos

NDK_TOOLCHAIN_VERSION := clang

ARCHITECTURE := armv7s
HOST := arm-apple-darwin
ALTHOST := arm-apple-darwin
ISYSROOT := -isysroot $(shell xcrun -sdk $(PLATFORM) --show-sdk-path)
MINVERSION_FLAG := -miphoneos-version-min=9.0

OPENSSL_TARGET := ios-cross

export CC := $(shell xcrun -find -sdk $(PLATFORM) cc)
export CXX := $(shell xcrun -find -sdk $(PLATFORM) g++)

export CPPFLAGS := -arch $(ARCHITECTURE) $(ISYSROOT) $(CPPFLAGS)
export CFLAGS := -O2 -arch $(ARCHITECTURE) $(MINVERSION_FLAG) $(CFLAGS)
export CXXFLAGS := -O2 -arch $(ARCHITECTURE) $(MINVERSION_FLAG) $(CXXFLAGS)
export LDFLAGS := -arch $(ARCHITECTURE) $(MINVERSION_FLAG) $(ISYSROOT) $(LDFLAGS)
