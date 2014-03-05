#!/bin/bash
##########################################################################################
#buildScript_libwebsockets_Library_Static_Darwin_UniversalBinary.sh
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

if ((0)); then
  git clone git://git.libwebsockets.org/libwebsockets
fi

if [ -d libwebsockets ]; then
  cd libwebsockets
  mkdir build
  cd build 
  mkdir -p build-i386 build-x86_64
  
# Build i386 binary
  cd build-i386
  cmake -DCMAKE_OSX_ARCHITECTURES=i386 ../..
  make
  if [ -f lib/libwebsockets.a ]; then
    mv lib/libwebsockets.a ../../../libwebsockets_i386.a
  fi
  make clean
  cd ..
  
# Build x86_64 binary
  cd build-x86_64
  cmake -DCMAKE_OSX_ARCHITECTURES=x86_64 ../..
  make
  if [ -f lib/libwebsockets.a ]; then
    mv lib/libwebsockets.a ../../../libwebsockets_x86_64.a
  fi
  make clean
  cd ..
  
# Back to original directory
  cd ..
  cd ..
  
# Merge i386 and x86_64 binary into one binary
  lipo -create -output libwebsockets.a libwebsockets_i386.a libwebsockets_x86_64.a
  strip -S libwebsockets.a
  lipo -info libwebsockets.a
  
# Final clean works
  rm -f libwebsockets_i386.a libwebsockets_x86_64.a
  rm -rf libwebsockets
fi
