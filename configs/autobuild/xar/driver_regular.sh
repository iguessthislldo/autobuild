#!/bin/sh
#
# $Id$
#

# Make sure autobuild directory is up to date.
cd $HOME/autobuild
svn up

exec /usr/bin/perl $HOME/autobuild/autobuild.pl \
  $HOME/autobuild/configs/autobuild/xar/footprint_regular.xml