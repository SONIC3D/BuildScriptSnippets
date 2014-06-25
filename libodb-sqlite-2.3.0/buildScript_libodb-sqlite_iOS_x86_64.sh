#!/bin/sh

set -xe
BUILDDIR=`pwd`
LIBODBBUILDDIR="$BUILDDIR/../libodb-2.3.0"
DESTDIR="BuildOutput"

#iOS x86_64(Simulator) Build Start
ARCH="x86_64"
IOSMV="-miphoneos-version-min=7.0"

PATH=`xcodebuild -version -sdk iphonesimulator PlatformPath`"/Developer/usr/bin:$PATH" \
CC="xcrun --sdk iphonesimulator clang -arch $ARCH $IOSMV" \
CXX="xcrun --sdk iphonesimulator clang++ -arch $ARCH $IOSMV" \
CPPFLAGS="-I$LIBODBBUILDDIR/$DESTDIR/OSX_Universal/include" \
LDFLAGS="-L$LIBODBBUILDDIR/$DESTDIR/OSX_Universal/lib" \
./configure \
CXXFLAGS="-Os" \
--host=arm-apple-darwin \
--disable-shared \
--prefix=$BUILDDIR/$DESTDIR/iOS_$ARCH

make
make install
make clean
#iOS x86_64 Build End
