#!/bin/bash

EXTERNAL_ROOT=$(pwd)
BUILD_DIR=$EXTERNAL_ROOT/tor
VERSION=$(python -c 'import re;print(re.search("define VERSION \"(.+)\"", open("tor/orconfig.h").read()).group(1))')

cat tor/orconfig.h | \
    sed s/$VERSION/{{.StrVer}}/g | \
    sed s/$(echo $BUILD_DIR | sed s/'\/'/'\\\/'/g)//g | \
    sed s/$(echo $EXTERNAL_ROOT | sed s/'\/'/'\\\/'/g)//g | \
    sed -e $'s/#define BUILDDIR ""/#define BUILDDIR ""\\\n\\\n#define SHARE_DATADIR ""\\\n\\\n#define LOCALSTATEDIR ""/g'
