#!/bin/sh

#
# This script packages the files needed to build an RPM file
# for autorevision. A standard RPM build environment
# is required.
#

# RPMBUILD option
STAGE=$1
SHORT_CIRCUIT=$2

APP=autorevision
VERSION=1.10a
PKG=${APP}-${VERSION}
SPEC=${APP}.spec

PKG_BASE=/tmp/rpm$$

# Standard RPM build tree
RPM_BUILD=$HOME/rpmbuild

FILES="
	AUTHORS.txt
	autorevision
	autorevision.1
	autorevision.html
	contribs
	CONTRIBUTING.html
	COPYING.html
	examples
	NEWS
	README.html
	"


# Check for and make the standard setup
if [ -x "/usr/bin/rpmdev-setuptree" ]
then
    [ -d $RPM_BUILD ] || /usr/bin/rpmdev-setuptree
else
    echo
    echo "   You need to load the rpmdevtools package!"
    echo
    echo "   After that, rerun this script and the standard RPM build structure"
    echo "   will be created for you in $RPM_BUILD."
    echo
    exit 1
fi

usage()
{
    echo
    echo "   Usage: $(basename $0) [p | c | i | l | b | s | a] [short]"
    echo
    echo "          h : show help"
    echo "          p : prep"
    echo "          c : build"
    echo "          i : install"
    echo "          l : list check"
    echo "          b : build binary package (default)"
    echo "          s : build source package"
    echo "          a : build binary and source package"
    echo "      short : short-circuit step"
    echo
    exit 1
}

case "$STAGE" in

    '') STAGE='b' ;;

    h | -h | --help) usage ;;

    p | c | i | l | b | s | a) break ;;

    *) usage ;;

esac

[ "$SHORT_CIRCUIT" ] && SHORT_CIRCUIT='--short-circuit'

trap "rm -rf $PKG_BASE; exit 0" EXIT ERR QUIT TERM


# If short-circuiting, don't generate new build files
if [ -z "$SHORT_CIRCUIT" ]
then
    # Cleanup source directory
    make devclean
    
    # Pre-cleaning
    mkdir -p $PKG_BASE/$PKG

    # Needs a markdown converter installed (e.g. python-markdown)
    make all docs
    
    # Copy the system files to the package
    cp -r $FILES $PKG_BASE/$PKG
    
    # Make the source archive for rpmbuild
    tar czf $RPM_BUILD/SOURCES/${PKG}.tar.gz -C $PKG_BASE $PKG

    # Copy the spec file to the build location
    cp autorevision.spec $RPM_BUILD/SPECS
fi

# Create package
rpmbuild -b$STAGE $SHORT_CIRCUIT $RPM_BUILD/SPECS/$SPEC

