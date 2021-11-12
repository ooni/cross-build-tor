NDK_TOOLCHAIN_VERSION := clang

ARCHITECTURE := arm64
HOST := arm-apple-darwin
ALTHOST := arm-apple-darwin
PLATFORM := iphoneos
ISYSROOT := "-isysroot $(shell xcrun -sdk $(PLATFORM) --show-sdk-path)"
MINVERSION_FLAG := "-miphoneos-version-min=9.0"

export CC := $(shell xcrun -find -sdk $(platform) cc)
export CXX := $(shell xcrun -find -sdk $(platform) g++)

export CPPFLAGS := "-arch $(ARCHITECTURE) $(ISYSROOT) $(CPPFLAGS)"
export CFLAGS := "-O2 -arch $(ARCHITECTURE) $(MINVERSION_FLAG) $(CFLAGS)"
export CXXFLAGS := "-O2 -arch $(ARCHITECTURE) $(MINVERSION_FLAG) $(CXXFLAGS)"
export LDFLAGS := "-arch $(ARCHITECTURE) $(MINVERSION_FLAG) $(ISYSROOT) $(LDFLAGS)"

