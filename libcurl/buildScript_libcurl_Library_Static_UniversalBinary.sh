#!/bin/bash
##########################################################################################
#buildScript_libcurl_Library_Static_UniversalBinary.sh
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
CURL_PKG_FILENAME="curl-7.35.0"
CURL_PKG_FILENAMEFULL=$CURL_PKG_FILENAME".tar.gz"
# Build directory settings
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRCDIR=$DIR/$CURL_PKG_FILENAME
DESTDIR=$DIR/mac
MACOSX_DEPLOYMENT_TARGET="10.6"

if !([ -f $CURL_PKG_FILENAMEFULL ]);
then
   echo "File \"$CURL_PKG_FILENAMEFULL\" does not exist"
   curl --remote-name http://curl.haxx.se/download/$CURL_PKG_FILENAMEFULL
else
   echo "File \"$CURL_PKG_FILENAMEFULL\" exists"
fi

# Extract package
tar -xzvf $CURL_PKG_FILENAMEFULL
cd $CURL_PKG_FILENAME

# Start build works
rm -rf "$DESTDIR"
mkdir "$DESTDIR"

# Build i386 binary
cd "$SRCDIR"
make clean
env CFLAGS="-arch i386" LDFLAGS="-arch i386" ./configure --disable-shared --with-darwinssl --disable-ares --disable-ldap --disable-ldaps
make
cd lib/.libs
if [ -f libcurl.a ]; then
    mv libcurl.a $DESTDIR/libcurl_32.a
fi;

# Build x86_64 binary
cd "$SRCDIR"
make clean
env CFLAGS="-arch x86_64" LDFLAGS="-arch x86_64" ./configure --disable-shared --with-darwinssl --disable-ares --disable-ldap --disable-ldaps
make
cd lib/.libs
if [ -f libcurl.a ]; then
    mv libcurl.a $DESTDIR/libcurl_64.a
fi;

# Clean works
cd "$SRCDIR"
make clean
cd ..
rm -rf "$SRCDIR"

# create lipo library
cd "$DESTDIR"
lipo -create -output libcurl.a libcurl_32.a libcurl_64.a
rm libcurl_32.a libcurl_64.a
# strip
strip -S $DESTDIR/libcurl.a
# info
lipo -info $DESTDIR/libcurl.a
