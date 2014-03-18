#!/bin/bash
##########################################################################################
#buildScript_tolua++.sh
#
#You need Scons to build tolua++:
#  Download:
#    http://prdownloads.sourceforge.net/scons/scons-2.3.1.tar.gz
#  Install:
#    #> sudo python setup.py install
#
#Task finished by this script:
# 1.Build tolua++ in x86_64.
# 2.Build libtolua++.a and libtolua++_static.a in i386 and x86_64 then combine them in 
#   Universal Binary for Mac OSX.
# 3.Install tolua++ with normal tolua++ installation progress.
# (Usually it will be installed to /usr/local/,root priviledge required)
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
TOLUA_PKG_FILENAME="tolua++-1.0.93"
TOLUA_PKG_FILENAMEFULL=$TOLUA_PKG_FILENAME".tar.bz2"
# Build directory settings
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRCDIR=$DIR/$TOLUA_PKG_FILENAME
DESTDIR=$DIR/mac
MACOSX_DEPLOYMENT_TARGET="10.6"

if !([ -f $TOLUA_PKG_FILENAMEFULL ]);
then
   echo "File \"$TOLUA_PKG_FILENAMEFULL\" does not exist"
   curl --remote-name http://www.codenix.com/~tolua/$TOLUA_PKG_FILENAMEFULL
else
   echo "File \"$TOLUA_PKG_FILENAMEFULL\" exists"
fi

# Extract package
tar -xzvf $TOLUA_PKG_FILENAMEFULL

# Copy modified Makefile
cp MakefileModded/Makefile $LUA_PKG_FILENAME/
cp MakefileModded/src/Makefile $LUA_PKG_FILENAME/src/

# Start build works
rm -rf "$DESTDIR"
mkdir "$DESTDIR"

cd "$SRCDIR"

# Build i386 binary
scons -c
cp $DIR/SconsScriptModded/config_posix_i386.py $SRCDIR/config_posix.py
scons
if [ -f lib/libtolua++.a ]; then
    mv lib/libtolua++.a $DESTDIR/libtolua++_32.a
fi;
if [ -f lib/libtolua++_static.a ]; then
    mv lib/libtolua++_static.a $DESTDIR/libtolua++_static_32.a
fi;

# Build x86_64 binary
scons -c
cp $DIR/SconsScriptModded/config_posix_x86_64.py $SRCDIR/config_posix.py
scons
if [ -f lib/libtolua++.a ]; then
    mv lib/libtolua++.a $DESTDIR/libtolua++_64.a
fi;
if [ -f lib/libtolua++_static.a ]; then
    mv lib/libtolua++_static.a $DESTDIR/libtolua++_static_64.a
fi;

# Skip clean works here since we want to install it in later steps

# create lipo library
cd "$DESTDIR"
lipo -create -output libtolua++.a libtolua++_32.a libtolua++_64.a
rm libtolua++_32.a libtolua++_64.a
lipo -create -output libtolua++_static.a libtolua++_static_32.a libtolua++_static_64.a
rm libtolua++_static_32.a libtolua++_static_64.a
# strip
strip -S $DESTDIR/libtolua++.a
strip -S $DESTDIR/libtolua++_static.a
# info
lipo -info $DESTDIR/libtolua++.a
lipo -info $DESTDIR/libtolua++_static.a

# copy back to build dir and make install
cd "$SRCDIR"
cp $DESTDIR/libtolua++.a lib/
cp $DESTDIR/libtolua++_static.a lib/
sudo scons install

# Clean works
scons -c
cd "$DIR"
rm -rf "$TOLUA_PKG_FILENAME"

