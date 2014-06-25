#!/bin/sh

set -xe
BUILDDIR=`pwd`
DESTDIR="BuildOutput"

#iOS i386(Simulator) Build Start
ARCH="i386"
IOSMV="-miphoneos-version-min=7.0"

PATH=`xcodebuild -version -sdk iphonesimulator PlatformPath`"/Developer/usr/bin:$PATH" \
CC="xcrun --sdk iphonesimulator clang -arch $ARCH $IOSMV" \
CXX="xcrun --sdk iphonesimulator clang++ -arch $ARCH $IOSMV" \
./configure \
CXXFLAGS="-Os" \
--host=arm-apple-darwin \
--disable-shared \
--prefix=$BUILDDIR/$DESTDIR/iOS_$ARCH

make
make install
make clean
#iOS i386 Build End
