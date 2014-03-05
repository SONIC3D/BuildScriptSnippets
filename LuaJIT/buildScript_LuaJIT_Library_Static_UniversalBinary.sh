#!/bin/bash
##########################################################################################
#buildScript_LuaJIT_Library_Static_Darwin_UniversalBinary.sh
##########################################################################################
#The MIT License (MIT)
#
# Copyright (c) 2014 Lu ZongJing(sonic3d@gmail.com)
# All rights reserved.
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED BY Lu ZongJing "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
##########################################################################################

# Specify target LuaJIT version string 
LUAJIT_PKG_FILENAME="LuaJIT-2.0.1"
LUAJIT_PKG_FILENAMEFULL=$LUAJIT_PKG_FILENAME".tar.gz"
# Build directory settings
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRCDIR=$DIR/$LUAJIT_PKG_FILENAME/src
DESTDIR=$DIR/mac
MACOSX_DEPLOYMENT_TARGET="10.6"

if !([ -f $LUAJIT_PKG_FILENAMEFULL ]);
then
   echo "File \"$LUAJIT_PKG_FILENAMEFULL\" does not exist"
   curl --remote-name http://luajit.org/download/$LUAJIT_PKG_FILENAMEFULL
else
   echo "File \"$LUAJIT_PKG_FILENAMEFULL\" exists"
fi

# Extract package
tar -xzvf $LUAJIT_PKG_FILENAMEFULL
cd $LUAJIT_PKG_FILENAME

# Start build works
rm -rf "$DESTDIR"
mkdir "$DESTDIR"

cd "$SRCDIR"

# Build i386 binary
make clean
make CC="gcc -m32 -arch i386" libluajit.a
if [ -f libluajit.a ]; then
    mv libluajit.a $DESTDIR/libluajit_32.a
fi;

# Build x86_64 binary
make clean
make CC="gcc -m64 -arch x86_64" libluajit.a

if [ -f libluajit.a ]; then
    mv libluajit.a $DESTDIR/libluajit_64.a
fi;

# Clean works
make clean

# create lipo library
cd "$DESTDIR"
lipo -create -output libluajit.a libluajit_32.a libluajit_64.a
rm libluajit_32.a libluajit_64.a
# strip
strip -S $DESTDIR/libluajit.a
# info
lipo -info $DESTDIR/libluajit.a
