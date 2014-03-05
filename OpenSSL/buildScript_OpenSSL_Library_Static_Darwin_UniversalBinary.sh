#!/bin/bash
##########################################################################################
#buildScript_OpenSSL_Library_Static_Darwin_UniversalBinary.sh
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

# Switch for expected build target,DO NOT turn them all off
ENABLE_PPC_BUILD="0"
ENABLE_I386_BUILD="1"
ENABLE_X86_64_BUILD="1"
# Specify target openssl version string 
OPENSSL_PKG_FILENAME="openssl-1.0.1f"
OPENSSL_PKG_FILENAMEFULL=$OPENSSL_PKG_FILENAME".tar.gz"

if !([ -f $OPENSSL_PKG_FILENAMEFULL ]);
then
   echo "File \"$OPENSSL_PKG_FILENAMEFULL\" does not exist"
   curl --remote-name http://www.openssl.org/source/$OPENSSL_PKG_FILENAMEFULL
else
   echo "File \"$OPENSSL_PKG_FILENAMEFULL\" exists"
fi

# Extract package
tar -xzvf $OPENSSL_PKG_FILENAMEFULL
cd $OPENSSL_PKG_FILENAME

# Create build directory
rm -rf build
mkdir build
cd build
mkdir -p build-ppc build-i386 build-x86_64
cd ..

# Build PPC version
if (( $ENABLE_PPC_BUILD )); then
  echo "PPC build enabled"
  # build PPC version
  make clean
  ./Configure darwin-ppc-cc
  make build_libs
  mv *.a build/build-ppc
fi
# Build i386 version
if (($ENABLE_I386_BUILD)); then
  echo "i386 build enabled"
  make clean
  ./Configure darwin-i386-cc
  make build_libs
  mv *.a build/build-i386
fi
# Build x86_64 version
if (($ENABLE_X86_64_BUILD)); then
  echo "x86_64 build enabled"
  make clean
  ./Configure darwin64-x86_64-cc
  make build_libs
  mv *.a build/build-x86_64
fi
# Clean works
make clean

# Merge output library
cd build
for i in libssl.a libcrypto.a
do
  LIB_PPC_RELATIVE_PATH=""
  LIB_I386_RELATIVE_PATH=""
  LIB_X86_64_RELATIVE_PATH=""
  if (( $ENABLE_PPC_BUILD )); then
    LIB_PPC_RELATIVE_PATH="build-ppc/"$i
  fi
  if (( $ENABLE_I386_BUILD )); then
    LIB_I386_RELATIVE_PATH="build-i386/"$i
  fi
  if (( $ENABLE_X86_64_BUILD )); then
    LIB_X86_64_RELATIVE_PATH="build-x86_64/"$i
  fi
  
  lipo -create -output $i $LIB_PPC_RELATIVE_PATH $LIB_I386_RELATIVE_PATH $LIB_X86_64_RELATIVE_PATH
  #ranlib $i
  
  # Strip lib
  strip -S $i
  
  # Print info of the merged lib
  lipo -info $i
  
  # Move lib built to startup directory
  mv $i ../../
done

# Back to original directory
cd ..
cd ..

# Final clean works
rm -rf $OPENSSL_PKG_FILENAME