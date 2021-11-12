EXTERNAL_ROOT := $(shell pwd)

include android64.mk

export PKG_CONFIG_PATH := $(EXTERNAL_ROOT)/lib/pkgconfig/:$(PKG_CONFIG_PATH)

.PHONY = openssl-build

openssl:
	git clone -b OpenSSL_1_1_1-stable https://github.com/openssl/openssl

openssl/Makefile: openssl
	cd openssl && PATH=$(PATH) \
    ./Configure \
			no-comp no-dtls no-ec2m no-psk no-srp no-ssl2 no-ssl3 \
			no-camellia no-idea no-md2 no-md4 no-mdc2 no-rc2 no-rc4 no-rc5 no-rmd160 no-whirlpool \
			no-dso no-hw no-ui-console \
			no-shared no-unit-test \
			android-$(NDK_ABI) \
			-D__ANDROID_API__=$(NDK_PLATFORM_LEVEL) \
			--prefix=/ \
			--openssldir=/

openssl-build: openssl/Makefile
	PATH=$(PATH) \
		make -C openssl install_dev DESTDIR=$(EXTERNAL_ROOT)


libevent:
	git clone -b release-2.1.11-stable https://github.com/libevent/libevent.git

libevent/Makefile: libevent
	cd libevent && ./autogen.sh
	cd libevent && ./configure \
		--host=$(ALTHOST) \
		--disable-libevent-regress \
		--disable-samples \
		--disable-shared \
		--prefix=/

libevent-build: libevent/Makefile
	make -C libevent install DESTDIR=$(EXTERNAL_ROOT)

tor:
	git clone -b release-0.4.6 https://git.torproject.org/tor.git

tor/Makefile: tor libevent-build openssl-build
	cd tor && ./autogen.sh
	cd tor && ./configure \
		--host=$(ALTHOST) \
		--enable-android \
		--enable-pic \
		--enable-restart-debugging \
		--disable-zstd \
		--disable-lzma \
		--disable-tool-name-check \
		--enable-static-libevent --with-libevent-dir=$(EXTERNAL_ROOT) \
		--enable-static-openssl --with-openssl-dir=$(EXTERNAL_ROOT) \
		--disable-asciidoc

orconfig.h: tor
	bash fixup-orconfig.sh > orconfig.h
