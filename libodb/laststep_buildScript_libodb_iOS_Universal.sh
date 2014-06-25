#!/bin/sh

set -xe
BUILDDIR=`pwd`
DESTDIR="BuildOutput"
TARGETDIR=$BUILDDIR/$DESTDIR/iOS_Universal/lib
ARCHS="i386 x86_64 armv7 armv7s arm64"


mkdir -p $TARGETDIR

INPUT=""
for ARCH in $ARCHS; 
do
    INPUT="$INPUT $BUILDDIR/$DESTDIR/iOS_$ARCH/lib/libodb.a"
done
lipo -create $INPUT -output $TARGETDIR/libodb.a
strip -S $TARGETDIR/libodb.a

cp -aR $BUILDDIR/$DESTDIR/iOS_armv7/include $BUILDDIR/$DESTDIR/iOS_Universal/