#!/bin/sh
#
# $Id$
#

cd /export/home/build/ACE/autobuild

exec /usr/bin/perl /export/home/build/ACE/autobuild/autobuild.pl \
                             /export/home/build/ACE/autobuild/configs/autobuild/remedynl/sol10x86_suncc.xml
