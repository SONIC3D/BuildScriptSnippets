#!/bin/sh

set -xe
BUILDDIR=`pwd`
DESTDIR="BuildOutput"

#iOS i386(Simulator) Build Start
ARCH="i386"
IOSMV="-mios-simulator-version-min=5.0"

PATH=`xcodebuild -version -sdk iphonesimulator PlatformPath`"/Developer/usr/bin:$PATH" \
SDK=`xcodebuild -version -sdk iphonesimulator Path` \
CC="xcrun --sdk iphonesimulator clang -arch $ARCH $IOSMV --sysroot=$SDK -isystem $SDK/usr/include" \
CXX="xcrun --sdk iphonesimulator clang++ -arch $ARCH $IOSMV --sysroot=$SDK -isystem $SDK/usr/include" \
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
#iOS i386(Simulator) Build End
