PLATFORM := android

NDK_TOOLCHAIN_VERSION := clang
HOST := aarch64-linux-android
ALTHOST := $(HOST)
GREP_CHECK := aarch64
NDK_ABI := arm64
NDK_BIT := 64
NDK_PLATFORM_LEVEL := 21
NDK_PROCESSOR := x86_64
NDK_TOOLCHAIN := $(HOST)-$(NDK_TOOLCHAIN_VERSION)

NDK_SYSROOT := $(ANDROID_NDK_HOME)/platforms/android-$(NDK_PLATFORM_LEVEL)/arch-$(NDK_ABI)
NDK_UNAME := $(shell uname -s | tr '[A-Z]' '[a-z]')
NDK_TOOLCHAIN_BASE := $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(NDK_UNAME)-$(NDK_PROCESSOR)
OPENSSL_TARGET := android-$(NDK_ABI)

PATH := $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/darwin-x86_64/bin:$(PATH)

export CC := $(NDK_TOOLCHAIN_BASE)/bin/$(HOST)$(NDK_PLATFORM_LEVEL)-clang
