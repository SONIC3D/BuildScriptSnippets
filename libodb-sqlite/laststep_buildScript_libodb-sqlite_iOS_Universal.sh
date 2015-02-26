#!/bin/sh

# Build required lib for making Universal Binary
./buildScript_libodb-sqlite_iOS_arm64.sh
./buildScript_libodb-sqlite_iOS_armv7.sh
./buildScript_libodb-sqlite_iOS_armv7s.sh
./buildScript_libodb-sqlite_iOS_i386.sh
./buildScript_libodb-sqlite_iOS_x86_64.sh



# iOS Universal Build Start
LIBODB_VERSION=2.3.0
LIBODB_SQLITE_NAME="libodb-sqlite-"$LIBODB_VERSION
cd $LIBODB_SQLITE_NAME

set -xe
BUILDDIR=`pwd`
DESTDIR="BuildOutput"
TARGETDIR=$BUILDDIR/$DESTDIR/iOS_Universal/lib
ARCHS="i386 x86_64 armv7 armv7s arm64"


mkdir -p $TARGETDIR

INPUT=""
for ARCH in $ARCHS; 
do
    INPUT="$INPUT $BUILDDIR/$DESTDIR/iOS_$ARCH/lib/libodb-sqlite.a"
done
lipo -create $INPUT -output $TARGETDIR/libodb-sqlite.a
strip -S $TARGETDIR/libodb-sqlite.a

cp -aR $BUILDDIR/$DESTDIR/iOS_armv7/include $BUILDDIR/$DESTDIR/iOS_Universal/

cd ..
#iOS Universal Build End