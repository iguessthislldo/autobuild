#!/bin/sh
#
# $Id$
#
CVSROOT=:ext:ucibuilds@cvs.doc.wustl.edu:/project/cvs-repository
export CVSROOT

CVS_RSH=/usr/bin/ssh
export CVS_RSH

PATH=/usr/local/redhat-7.1/gcc-3.0.2/bin:$PATH
export PATH

LD_LIBRARY_PATH=$ACE_ROOT/ace:/usr/local/redhat-7.1/gcc-3.0.2/lib
export LD_LIBRARY_PATH

cd $ACE_ROOT
cd ..
cvs -r -z 3 -Q checkout -P autobuild

perl -w ./autobuild/autobuild.pl autobuild/configs/autobuild/maedhros/Core.xml

#WEBLOG=$HOME/.www-docs/auto_compile_logs/maedhros_Core
#
#DATE=`date -u +%Y_%m_%d_%H_%M`
#/bin/cp build_log.txt $WEBLOG/$DATE.txt
#perl -w ./autobuild/make_pretty.pl -b -c makefile -i $WEBLOG/$DATE.txt \
#    -o $WEBLOG/${DATE}_brief.html
#perl -w ./autobuild/make_pretty.pl    -c makefile -i $WEBLOG/$DATE.txt \
#    -o $WEBLOG/${DATE}.html
    
