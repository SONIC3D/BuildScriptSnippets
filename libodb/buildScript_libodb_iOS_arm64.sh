#!/bin/sh

set -xe
BUILDDIR=`pwd`
DESTDIR="BuildOutput"

#iOS arm64 Build Start
ARCH="arm64"
IOSMV="-miphoneos-version-min=7.0"

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
#iOS arm64 Build End
