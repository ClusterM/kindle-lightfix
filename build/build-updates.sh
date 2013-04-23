#! /bin/sh
#
# $Id: build-updates.sh
#

HACKNAME="lightfix"
PKGNAME="${HACKNAME}"
PKGVER="0.0.1"

# We need kindletool (https://github.com/NiLuJe/KindleTool) in $PATH
if (( $(kindletool version | wc -l) == 1 )) ; then
	HAS_KINDLETOOL="true"
fi

if [[ "${HAS_KINDLETOOL}" != "true" ]] ; then
	echo "You need KindleTool (https://github.com/NiLuJe/KindleTool) to build this package."
	exit 1
fi

# We also need GNU tar
TAR_BIN="tar"
if ! ${TAR_BIN} --version | grep "GNU tar" > /dev/null 2>&1 ; then
	echo "You need GNU tar to build this package."
	exit 1
fi

## Install
# Create the utils tarball
${TAR_BIN} --owner root --group root -cvzf utils.tar.gz consts ui

# Archive custom directory
#${TAR_BIN} --owner root --group root --exclude="*.svn" -cvzf ${HACKNAME}.tar.gz ../src/${HACKNAME}

# Copy the script to our working directory, to avoid storing crappy paths in the update package
cp ../src/install.sh ./

# Build the install package
kindletool create ota2 -d kindle5 utils.tar.gz install.sh update_${PKGNAME}_${PKGVER}_install.bin

## Uninstall
# Copy the script to our working directory, to avoid storing crappy paths in the update package
cp ../src/uninstall.sh ./

# Build the install package
kindletool create ota2 -d kindle5 utils.tar.gz uninstall.sh update_${PKGNAME}_${PKGVER}_uninstall.bin

## Cleanup
# Remove package specific temp stuff
rm -f ./install.sh ./uninstall.sh ./utils.tar.gz

# Move our updates
mv -f *.bin ../
