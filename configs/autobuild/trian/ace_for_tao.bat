REM $Id$

call "C:\Program Files\Microsoft Visual Studio .NET 2003\Common7\Tools\vsvars32.bat"

cd "C:\ACE\autobuild"

svn up

perl autobuild.pl configs\autobuild\trian\ace_for_tao.xml