#!/bin/sh

# Specify target libodb version string 
LIBODB_VERSION_DIR=2.3
LIBODB_VERSION=2.3.0
LIBODB_PKG_FILENAME="libodb-"$LIBODB_VERSION
LIBODB_PKG_FILENAMEFULL=$LIBODB_PKG_FILENAME".tar.gz"

if !([ -f $LIBODB_PKG_FILENAMEFULL ]);
then
   echo "File \"$LIBODB_PKG_FILENAMEFULL\" does not exist."
   curl --remote-name http://www.codesynthesis.com/download/odb/$LIBODB_VERSION_DIR/$LIBODB_PKG_FILENAMEFULL
else
   echo "File \"$LIBODB_PKG_FILENAMEFULL\" already exists."
fi

if !([ -f $LIBODB_PKG_FILENAMEFULL ]);
then
   echo "File \"$LIBODB_PKG_FILENAMEFULL\" download failed."
else
	# Extract package
	tar -xzvf $LIBODB_PKG_FILENAMEFULL

	# Start build works
	./laststep_buildScript_libodb_iOS_Universal.sh
	./laststep_buildScript_libodb_OSX_Universal.sh
fi
