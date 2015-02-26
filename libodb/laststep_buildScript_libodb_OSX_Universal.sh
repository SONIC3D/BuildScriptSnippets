#!/bin/sh

#Build required lib for making Universal Binary
./buildScript_libodb_OSX_i386.sh
./buildScript_libodb_OSX_x86_64.sh






#OSX Universal Build Start
LIBODB_VERSION=2.3.0
LIBODB_NAME="libodb-"$LIBODB_VERSION
cd $LIBODB_NAME

set -xe
BUILDDIR=`pwd`
DESTDIR="BuildOutput"
TARGETDIR=$BUILDDIR/$DESTDIR/OSX_Universal/lib
ARCHS="i386 x86_64"


mkdir -p $TARGETDIR

INPUT=""
for ARCH in $ARCHS; 
do
    INPUT="$INPUT $BUILDDIR/$DESTDIR/OSX_$ARCH/lib/libodb.a"
done
lipo -create $INPUT -output $TARGETDIR/libodb.a
strip -S $TARGETDIR/libodb.a

cp -aR $BUILDDIR/$DESTDIR/OSX_i386/include $BUILDDIR/$DESTDIR/OSX_Universal/

cd ..
#OSX Universal Build End
