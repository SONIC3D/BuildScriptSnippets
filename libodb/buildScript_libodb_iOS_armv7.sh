#!/bin/sh

set -xe
BUILDDIR=`pwd`
DESTDIR="BuildOutput"

#iOS armv7 Build Start
ARCH="armv7"
IOSMV="-miphoneos-version-min=5.0"

PATH=`xcodebuild -version -sdk iphoneos PlatformPath`"/Developer/usr/bin:$PATH" \
SDK=`xcodebuild -version -sdk iphoneos Path` \
CC="xcrun --sdk iphoneos clang -arch $ARCH $IOSMV --sysroot=$SDK -isystem $SDK/usr/include" \
CXX="xcrun --sdk iphoneos clang++ -arch $ARCH $IOSMV --sysroot=$SDK -isystem $SDK/usr/include" \
LDFLAGS="-Wl,-syslibroot,$SDK" \
./configure \
CXXFLAGS="-Os" \
--disable-threads \
--host=arm-apple-darwin \
--disable-shared \
--prefix=$BUILDDIR/$DESTDIR/iOS_$ARCH

make
make install
make clean
#iOS armv7 Build End
