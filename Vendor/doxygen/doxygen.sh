#!/bin/bash
#
# Shamelessly cribbed from:
# http://trac.cafu.de/browser/cafu/trunk/ExtLibs/wxWidgets/docs/doxygen/regen.sh
#

GENERATOR=`which doxygen`
CONFIG=dummy.config
PROJECT_NAME="ObjectiveModel"
DOCSET_FEEDNAME="$PROJECT_NAME Library Reference"
DOCSET_BUNDLE_ID=us.f1337.ObjectiveModel


# generate a clean doxygen config file
$GENERATOR -g $CONFIG

# http://developer.apple.com/library/mac/#featuredarticles/DoxygenXcode/_index.html
# "Append the proper input/output directories and docset info to the config file.
#  This works even though values are assigned higher up in the file. Easier than sed."
echo "
PROJECT_NAME           = \"$PROJECT_NAME\"
PROJECT_BRIEF          = \"An ActiveModel implementation for Objective-C.\"
#PROJECT_LOGO           = /Users/hellokitty/Desktop/logo.gif
INPUT                  = ../ObjectiveModel
RECURSIVE              = YES
TAB_SIZE               = 16
EXTRACT_ALL            = NO # Do NOT set to YES! Doing so doubles the doc generation time!
EXTRACT_STATIC         = YES
HIDE_SCOPE_NAMES       = YES
EXCLUDE                = RK*
EXCLUDE_PATTERNS       = */.svn/* */._*
HTML_DYNAMIC_SECTIONS  = YES
GENERATE_DOCSET        = YES
DOCSET_FEEDNAME        = \"$DOCSET_FEEDNAME\"
DOCSET_BUNDLE_ID       = $DOCSET_BUNDLE_ID
DOCSET_PUBLISHER_ID    = us.f1337.michael
DOCSET_PUBLISHER_NAME  = \"Michael R. Fleet\"
GENERATE_LATEX         = NO
" >> $CONFIG



#
# Shamelessly cribbed from:
# http://trac.cafu.de/browser/cafu/trunk/ExtLibs/wxWidgets/docs/doxygen/regen.sh
#
DOCSETNAME="$DOCSET_BUNDLE_ID.docset"
DOCSETBASEURL="http://michael.f1337.us/docsets"
ATOM="$DOCSETNAME.atom"
ATOMDIR="$DOCSETBASEURL/$PROJECT_NAME/docset"
XAR="$DOCSETNAME.xar"
XARDIR="$DOCSETBASEURL/$PROJECT_NAME/docset"
XCODE_INSTALL=`sh xcode-select -print-path`


# delete the old documentation
rm -rf html
rm -f $XAR
rm -f $ATOM
rm -rf $DOCSETNAME

# generate the documentation
$GENERATOR $CONFIG

# make the new docset
make -C html
mv html/$DOCSETNAME ./

# tweak the docset config before packaging
DESTINATIONDIR=`pwd`
# defaults write $DESTINATIONDIR/$DOCSETNAME/Contents/Info CFBundleVersion 1.3
# defaults write $DESTINATIONDIR/$DOCSETNAME/Contents/Info CFBundleShortVersionString 1.3
defaults write $DESTINATIONDIR/$DOCSETNAME/Contents/Info CFBundleName "$PROJECT_NAME"
# the "secret sauce" needed for docsetutil to create an ATOM feed from Doxygen output
defaults write $DESTINATIONDIR/$DOCSETNAME/Contents/Info DocSetFeedURL $ATOMDIR/$ATOM
defaults write $DESTINATIONDIR/$DOCSETNAME/Contents/Info DocSetFallbackURL http://m.chase.com
defaults write $DESTINATIONDIR/$DOCSETNAME/Contents/Info DocSetDescription "$DOCSET_FEEDNAME"
defaults write $DESTINATIONDIR/$DOCSETNAME/Contents/Info NSHumanReadableCopyright "Copyright © 2011 - 2012 Michael R. Fleet"

# run docsetutil
$XCODE_INSTALL/usr/bin/docsetutil package -atom $ATOM -download-url $XARDIR/$XAR -output $XAR $DESTINATIONDIR/$DOCSETNAME



# Construct the applescript which tells Xcode to load the new docset.
LOAD_DOCSET_PATH="loadDocSet.scpt"

#  Remove old applescript file, in case there already is one.
rm -f "$LOAD_DOCSET_PATH"

#  Echo three lines of text into the file
echo "tell application \"Xcode\"" >> "$LOAD_DOCSET_PATH"
echo "load documentation set with path \"$DESTINATIONDIR/$DOCSETNAME\"" >> "$LOAD_DOCSET_PATH"
echo "end tell" >> "$LOAD_DOCSET_PATH"

#  Run the load-docset applescript command.
osascript "$LOAD_DOCSET_PATH"

echo
echo "*** This script is now done."
echo

exit 0
