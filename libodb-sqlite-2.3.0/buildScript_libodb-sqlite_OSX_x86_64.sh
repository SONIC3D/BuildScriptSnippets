#!/bin/sh

set -xe
BUILDDIR=`pwd`
LIBODBBUILDDIR="$BUILDDIR/../libodb-2.3.0"
DESTDIR="BuildOutput"

#OSX x86_64 Build Start
ARCH="x86_64"
OSXMV="-mmacosx-version-min=10.6"
SDKNAME="macosx"

PATH=`xcodebuild -version -sdk $SDKNAME PlatformPath`"/Developer/usr/bin:$PATH" \
SDK=`xcodebuild -version -sdk $SDKNAME Path` \
CC="xcrun --sdk $SDKNAME clang -arch $ARCH $OSXMV --sysroot=$SDK -isystem $SDK/usr/include" \
CXX="xcrun --sdk $SDKNAME clang++ -arch $ARCH $OSXMV --sysroot=$SDK -isystem $SDK/usr/include" \
CPPFLAGS="-I$LIBODBBUILDDIR/$DESTDIR/OSX_Universal/include" \
LDFLAGS="-Wl,-syslibroot,$SDK,-L$LIBODBBUILDDIR/$DESTDIR/OSX_Universal/lib" \
./configure \
CXXFLAGS="-Os" \
--disable-threads \
--host=arm-apple-darwin \
--disable-shared \
--prefix=$BUILDDIR/$DESTDIR/OSX_$ARCH

make
make install
make clean
#OSX x86_64 Build End
