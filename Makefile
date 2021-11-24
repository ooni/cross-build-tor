EXTERNAL_ROOT := $(shell pwd)

ifdef TARGET_PLATFORM
	include $(TARGET_PLATFORM).mk
endif

export PKG_CONFIG_PATH := $(EXTERNAL_ROOT)/lib/pkgconfig:$(PKG_CONFIG_PATH)
export CPATH := $(EXTERNAL_ROOT)/include:$(CPATH)

.PHONY = openssl-build libevent-build tor/Makefile

openssl:
	git clone -b OpenSSL_1_1_1-stable https://github.com/openssl/openssl

openssl/Makefile: openssl
ifeq ($(PLATFORM),android)
	cd openssl && PATH=$(PATH) \
    ./Configure \
			no-comp no-dtls no-ec2m no-psk no-srp no-ssl2 no-ssl3 \
			no-camellia no-idea no-md2 no-md4 no-mdc2 no-rc2 no-rc4 no-rc5 no-rmd160 no-whirlpool \
			no-dso no-hw no-ui-console \
			no-shared no-unit-test \
			$(OPENSSL_TARGET) \
			-D__ANDROID_API__=$(NDK_PLATFORM_LEVEL) \
			--prefix=/ \
			--openssldir=/
else ifeq ($(PLATFORM),iphoneos)
	cd openssl && PATH=$(PATH) \
    ./Configure \
			no-comp no-dtls no-ec2m no-psk no-srp no-ssl2 no-ssl3 \
			no-camellia no-idea no-md2 no-md4 no-mdc2 no-rc2 no-rc4 no-rc5 no-rmd160 no-whirlpool \
			no-dso no-hw no-ui-console \
			no-shared no-unit-test \
			$(OPENSSL_TARGET) \
			--prefix=/ \
			--openssldir=/
else
	echo "UNSUPPORTED PLATFORM"
	exit 1
endif

openssl-build: openssl/Makefile
	PATH=$(PATH) \
		make -C openssl install_dev DESTDIR=$(EXTERNAL_ROOT)

openssl-clean:
	-rm openssl-build-stamp
	-rm lib/libcrypto.a
	-rm lib/libssl.a
	-make -C openssl uninstall_dev > /dev/null
	-make -C openssl clean
	-cd openssl && \
		git clean -fdx > /dev/null

libevent:
	git clone https://github.com/libevent/libevent.git
	git checkout 0c217f4fe1af6efdb99321401da6f4048398065f

libevent/Makefile: libevent
	cd libevent && ./autogen.sh
	cd libevent && ./configure \
		PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
		--host=$(ALTHOST) \
		--disable-libevent-regress \
		--disable-samples \
		--disable-shared \
		--prefix=/

libevent-build: libevent/Makefile
	make -C libevent install DESTDIR=$(EXTERNAL_ROOT)

libevent-clean:
	-rm -f lib/libevent.a
	-rm -f libevent-build-stamp
	-make -C libevent uninstall DESTDIR=$(EXTERNAL_ROOT)
	-make -C libevent clean
	-cd libevent && \
		git clean -fdx > /dev/null

tor:
	git clone -b release-0.4.6 https://git.torproject.org/tor.git

tor/Makefile: tor libevent-build openssl-build
	cd tor && ./autogen.sh
ifeq ($(PLATFORM),android)
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
else ifeq ($(PLATFORM),iphoneos)
	cd tor && ./configure \
		--host=$(ALTHOST) \
		--enable-pic \
		--enable-restart-debugging \
		--disable-zstd \
		--disable-lzma \
		--disable-tool-name-check \
		--enable-static-libevent --with-libevent-dir=$(EXTERNAL_ROOT) \
		--enable-static-openssl --with-openssl-dir=$(EXTERNAL_ROOT) \
		--disable-asciidoc
else
	echo "UNSUPPORTED PLATFORM"
	exit 1
endif

orconfig.h: tor/Makefile
	bash fixup-orconfig.sh > orconfig.h

orconfig.h-clean:
	-rm orconfig.h

clean: openssl-clean libevent-clean orconfig.h-clean
