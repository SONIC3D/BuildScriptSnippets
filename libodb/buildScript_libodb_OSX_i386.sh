#!/bin/sh

LIBODB_VERSION=2.3.0
LIBODB_NAME="libodb-"$LIBODB_VERSION
cd $LIBODB_NAME

set -xe
BUILDDIR=`pwd`
DESTDIR="BuildOutput"

#OSX i386 Build Start
ARCH="i386"
OSXMV="-mmacosx-version-min=10.6"
SDKNAME="macosx"
OPTIMIZATION="-Os"
STDLIB="-stdlib=libstdc++"

PATH=`xcodebuild -version -sdk $SDKNAME PlatformPath`"/Developer/usr/bin:$PATH" \
SDK=`xcodebuild -version -sdk $SDKNAME Path` \
CC="xcrun --sdk $SDKNAME clang -arch $ARCH $OSXMV --sysroot=$SDK -isystem $SDK/usr/include" \
CXX="xcrun --sdk $SDKNAME clang++ -arch $ARCH $OSXMV --sysroot=$SDK -isystem $SDK/usr/include" \
LDFLAGS="-Wl,-syslibroot,$SDK" \
./configure \
CFLAGS="$OPTIMIZATION" \
CXXFLAGS="$OPTIMIZATION $STDLIB" \
--disable-threads \
--host=arm-apple-darwin \
--disable-shared \
--prefix=$BUILDDIR/$DESTDIR/OSX_$ARCH

make
make install
make clean
#OSX i386 Build End

cd ..
