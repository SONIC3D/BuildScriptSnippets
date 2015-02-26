#!/bin/sh

LIBODB_VERSION=2.3.0
LIBODB_NAME="libodb-"$LIBODB_VERSION
cd $LIBODB_NAME

set -xe
BUILDDIR=`pwd`
DESTDIR="BuildOutput"

#iOS armv7s Build Start
ARCH="armv7s"
IOSMV="-miphoneos-version-min=5.0"
SDKNAME="iphoneos"
OPTIMIZATION="-Os"
STDLIB="-stdlib=libstdc++"

PATH=`xcodebuild -version -sdk $SDKNAME PlatformPath`"/Developer/usr/bin:$PATH" \
SDK=`xcodebuild -version -sdk $SDKNAME Path` \
CC="xcrun --sdk $SDKNAME clang -arch $ARCH $IOSMV --sysroot=$SDK -isystem $SDK/usr/include" \
CXX="xcrun --sdk $SDKNAME clang++ -arch $ARCH $IOSMV --sysroot=$SDK -isystem $SDK/usr/include" \
LDFLAGS="-Wl,-syslibroot,$SDK" \
./configure \
CFLAGS="$OPTIMIZATION" \
CXXFLAGS="$OPTIMIZATION $STDLIB" \
--disable-threads \
--host=arm-apple-darwin \
--disable-shared \
--prefix=$BUILDDIR/$DESTDIR/iOS_$ARCH

make
make install
make clean
#iOS armv7s Build End

cd ..