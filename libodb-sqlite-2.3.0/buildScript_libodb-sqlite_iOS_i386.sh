#!/bin/sh

LIBODB_VERSION=2.3.0
LIBODB_NAME="libodb-"$LIBODB_VERSION
LIBODB_SQLITE_NAME="libodb-sqlite-"$LIBODB_VERSION
cd $LIBODB_SQLITE_NAME

set -xe
BUILDDIR=`pwd`
LIBODBBUILDDIR="$BUILDDIR/../$LIBODB_NAME"
DESTDIR="BuildOutput"

#iOS i386(Simulator) Build Start
ARCH="i386"
IOSMV="-mios-simulator-version-min=5.0"
SDKNAME="iphonesimulator"
OPTIMIZATION="-Os"
STDLIB="-stdlib=libstdc++"

PATH=`xcodebuild -version -sdk $SDKNAME PlatformPath`"/Developer/usr/bin:$PATH" \
SDK=`xcodebuild -version -sdk $SDKNAME Path` \
CC="xcrun --sdk $SDKNAME clang -arch $ARCH $IOSMV --sysroot=$SDK -isystem $SDK/usr/include" \
CXX="xcrun --sdk $SDKNAME clang++ -arch $ARCH $IOSMV --sysroot=$SDK -isystem $SDK/usr/include" \
CPPFLAGS="-I$LIBODBBUILDDIR/$DESTDIR/iOS_Universal/include" \
LDFLAGS="-Wl,-syslibroot,$SDK,-L$LIBODBBUILDDIR/$DESTDIR/iOS_Universal/lib" \
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
#iOS i386(Simulator) Build End

cd ..
