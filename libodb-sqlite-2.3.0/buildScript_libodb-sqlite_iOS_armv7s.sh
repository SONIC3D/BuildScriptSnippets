#!/bin/sh

set -xe
BUILDDIR=`pwd`
LIBODBBUILDDIR="$BUILDDIR/../libodb-2.3.0"
DESTDIR="BuildOutput"

#iOS armv7s Build Start
ARCH="armv7s"
IOSMV="-miphoneos-version-min=4.3"

PATH=`xcodebuild -version -sdk iphoneos PlatformPath`"/Developer/usr/bin:$PATH" \
SDK=`xcodebuild -version -sdk iphoneos Path` \
CC="xcrun --sdk iphoneos clang -arch $ARCH $IOSMV --sysroot=$SDK -isystem $SDK/usr/include" \
CXX="xcrun --sdk iphoneos clang++ -arch $ARCH $IOSMV --sysroot=$SDK -isystem $SDK/usr/include" \
CPPFLAGS="-I$LIBODBBUILDDIR/$DESTDIR/OSX_Universal/include" \
LDFLAGS="-Wl,-syslibroot,$SDK,-L$LIBODBBUILDDIR/$DESTDIR/OSX_Universal/lib" \
./configure \
CXXFLAGS="-Os" \
--host=arm-apple-darwin \
--disable-shared \
--prefix=$BUILDDIR/$DESTDIR/iOS_$ARCH

make
make install
make clean
#iOS armv7s Build End
