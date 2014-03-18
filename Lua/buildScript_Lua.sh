#!/bin/bash
##########################################################################################
#buildScript_Lua.sh
#
#Task finished by this script:
#1.Build lua luac in x86_64.
#2.Build liblua.a in i386 and x86_64 then combine them in Universal Binary for Mac OSX.
#3.Install lua luac and combined liblua.a with normal lua install progress.
#(Usually it will be installed to /usr/local/,root priviledge required)
#
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
LUA_PKG_FILENAME="lua-5.1.5"
LUA_PKG_FILENAMEFULL=$LUA_PKG_FILENAME".tar.gz"
# Build directory settings
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRCDIR=$DIR/$LUA_PKG_FILENAME
DESTDIR=$DIR/mac
MACOSX_DEPLOYMENT_TARGET="10.6"

if !([ -f $LUA_PKG_FILENAMEFULL ]);
then
   echo "File \"$LUA_PKG_FILENAMEFULL\" does not exist"
   curl --remote-name http://www.lua.org/ftp/$LUA_PKG_FILENAMEFULL
else
   echo "File \"$LUA_PKG_FILENAMEFULL\" exists"
fi

# Extract package
tar -xzvf $LUA_PKG_FILENAMEFULL

# Copy modified Makefile
cp MakefileModded/Makefile $LUA_PKG_FILENAME/
cp MakefileModded/src/Makefile $LUA_PKG_FILENAME/src/

# Start build works
rm -rf "$DESTDIR"
mkdir "$DESTDIR"

cd "$SRCDIR"

# Build i386 binary
make clean
make macosx_i386
if [ -f src/liblua.a ]; then
    mv src/liblua.a $DESTDIR/liblua_32.a
fi;

# Build x86_64 binary
make clean
make macosx_x86_64

if [ -f src/liblua.a ]; then
    mv src/liblua.a $DESTDIR/liblua_64.a
fi;

# Skip clean works here since we want to install it in later steps

# create lipo library
cd "$DESTDIR"
lipo -create -output liblua.a liblua_32.a liblua_64.a
rm liblua_32.a liblua_64.a
# strip
strip -S $DESTDIR/liblua.a
# info
lipo -info $DESTDIR/liblua.a

# copy back to build dir and make install
cd "$SRCDIR"
cp $DESTDIR/liblua.a src/
sudo make install

# Clean works
make clean
cd "$DIR"
rm -rf "$LUA_PKG_FILENAME"

