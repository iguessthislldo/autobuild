[![tests](https://github.com/DOCGroup/autobuild/actions/workflows/tests.yml/badge.svg)](https://github.com/DOCGroup/autobuild/actions/workflows/tests.yml)

# Autobuild and scoreboard tools

## Autobuild Introduction

The autobuild tools are a set of perl scripts, perl modules and
XML configuration files to automatically build our projects
on multiple platforms.  The tools run on Unix (several flavors) and
Windows NT/2k/XP.

SOFTWARE REQUIREMENTS
=====================

1. perl 5.6.1 or higher

2. Libwww-perl module.  You can get this from http://www.cpan.org.
   Red Hat Linux distributions may have an optional package perl-libwww-perl.


QUICK GUIDE GETTING STARTED WITH AUTOBUILD
==========================================

1. Check out the latest build scripts from git using:

       git clone https://github.com/DOCGroup/autobuild

2. Look at the existing XML configuration files in
   autobuild/configs/autobuild/*.  Create a new XML configuration
   for your build and customize it according
   to your local site.

   In the `<configuration></configuration>` section, you can set environment
   variables like `ACE_ROOT`, `PATH`, `CVSROOT`, `LD_LIBRARY_PATH`, etc. For example:

         <environment name="ACE_ROOT"        value="/export/bugzilla/Minimum_newbuild/ACE_wrappers" />

   The "root" variable is important. It is the root of all future
   "file_manipulation" commands.

   The "configs" variable should contain a space-separated list of -Config
   options that are passed to auto_run_tests.pl. For Windows, it should
   include Win32.

   The "make_program" variable enabled you to specify a different executable
   to call for make.

3. In the `<configuration></configuration>` section, specify the directory
   where to place the log files from the build.
   Ideally this directory should be accessible by a web server, so
   that you can see the log files via http. For example:

         <variable name="log_root" value="/home/bugzilla/.www-docs/auto_compile_logs/curufin_SingleThreaded" />

4. To run the build, you run autobuild.pl with the XML config file as the
    argument:

         autobuild.pl Debian_Minimum_Static.xml

5. To update a scoreboard, you run scoreboard.pl with input xml as the
    argument:

         scoreboard.pl -d [Output directory where the html files are placed]
                       -f [name and path of the XML file that needs
                           to be used as a meta-file for HTML
                           generation]
                       -o [name of the output file. The html file will
                           be saved by this name and placed in the
                           directory pointed by -d].


OTHER NOTES
===========
1.  In the `<configuration></configuration>` section, you set shell environment variables with the following tag:

         <environment name="ENV VARIABLE NAME"  value="ENV VARIABLE VALUE" />

2.  In the `<configuration></configuration>` section, you set Perl global variables with the following tag:

         <variable name="PERL GLOBAL VARIABLE NAME"  value="VARIABLE VALUE" />

3.  Outside the configuration section, commands are specified with the following tag:

         <command name="COMMAND NAME" options="COMMAND OPTIONS" />

     Each command is located in Perl modules in the autobuild/command
     directory.  If you look in each Perl module, you will see a line
     such as:

         main::RegisterCommand ("COMMAND NAME", new COMMAND ());

     This line registers "COMMAND NAME" in a global table used by
     autobuild.pl to locate a command specified in the XML file.

4.  To run an arbitrary command for which a Perl "command module" has
     not been written, you can use the "shell" command.  For example, to run
     the ls command on a Unix system:

         <command name="shell" options="ls" />

5.  When setting up a Windows build system make sure you disable the firewall
     and the automatic windows updates.

SCOREBOARD NOTES
===================

1. PDF - to display a PDF file use the `<pdf>` build option in the
    configuration file for the `scoreboard.pl` script. For example,
    `<pdf>test.pdf</pdf>` will cause a hyperlink to appear called
    `pdf` to appear on that row in the scoreboard. Clicking on the
    link will download/open the file. A column header will appear
    called PDF. If this tag is the config file then the column will
    not appear in the screen. This is useful if you use doxygen to
    create postscript output and convert it to PDF format for
    greater reader usability.

    The `<url>` contents plus the `<pdf>` contents are used to
    refer to the document on the webserver. So if the `<url>` is
    `http://deuce.doc.wustl.edu/test/machine_one_wustl_edu` and the
    `<pdf>` is `test.pdf`, the webserver will look for the file at
    `http://deuce.doc.wustl.edu/test/machine_one_wustl_edu/test.pdf`

2. PS - to display a PS file use the `<ps>` build option in the
    configuration file for the `scoreboard.pl` script. For example,
    `<ps>test.ps</ps>` will cause a hyperlink to appear called
    'ps' to appear on that row in the scoreboard. Clicking on the
    link will download/open the file. A column header will appear
    called PS. If this tag is the config file then the column will
    not appear on the screen. This is useful if you use doxygen to
    create postscript output.

    The `<url>` contents plus the `<ps>` contents are used to
    refer to the document on the webserver. So if the `<url>` is
    `http://deuce.doc.wustl.edu/test/machine_one_wustl_edu` and the
    `<ps>` is `test.ps`, the webserver will look for the file at
    `http://deuce.doc.wustl.edu/test/machine_one_wustl_edu/test.ps`

3. HTML - to display a HTML file use the `<html>` build option in the
    configuration file for the scoreboard.pl script. For example,
    `<html>test.html</html>` will cause a hyperlink to appear called
    `html` to appear on that row in the scoreboard. Clicking on the
    link will download/open the file. A column header will appear
    called HTML. If this tag is not in the config file then the
    column will not appear on the screen. This is useful if you
    use doxygen to create html output.

4. SNAPSHOT - for users of automake and autoconf, to display a
    created snapshot of the present code, use the
    `<snapshot>test.tar.gz</snapshot>`. This will cause a hyperlink
    to appear called 'snapshot' to appear on that row in the
    scoreboard. Clicking on the link will download/open the file.
    A column header will appear called SNAPSHOT. If this tag is
    not in the config file then the column will not appear on the
    screen for that row. This is useful if you want to release
    a snapshot of the CVS repository ready for a user to download
    and run "./configure".

5. The time of last build on the scoreboard is colored to show
    when a build is late. Non-late builds are white, late builds
    are orange, and very late builds are red.  The defaults for
    orange and red are 24 and 48 hours respectively.  These are
    based on the assumption that builds will run daily or less,
    perhaps continuously.  The values for orange and red can be
    changed for individual builds with the parameters
    `<orange>hours</orange>` and `<red>hours</red>`.

6. A schedule file is available for less than daily builds.  This
    file has an .ini format.  Build names are specified in square
    brackets and parameters follow.  The one the scoreboard uses
    is "runon" with a list of days (date abbrevs).  For example,
      [build_xyz]
      runon Mon Thu
    thus, build_xyz will not be considered late until the current
    time passes the next build by the amount specified in orange and
    red plus the number of days between the last and next builds.
    This feature is activated by the presence of the -s <file>
    switch.

7. There are situations where you may have a number of system that
    share a single data store, via NFS and/or SMB.  In this case you
    may wish to have the machine running scoreboard.pl do some of the
    function normally done by autobuild.pl, specifically the
    maintenance of the output logs.  This can be accomplished with
    the -c option.  When this option is specified the directory
    specified in the required -d option is maintained by the
    scoreboard program.  This allows, for example, the autobuild to
    specify only "process_logs move" and the remainder, "prettify,
    clean, and index" will be done by the scoreboard.  It also allows
    the faster relative refs to be used as url or skipped entirely,
    if the name of the build matches the name of the sub-directory.

8. To retain the full capabilities of autobuild.pl in the situation
    above(7).  The KEEP parameter was added to the scoreboard.  The
    value for keep can be specified globally with the -k switch to
    scoreboard.pl or for individual builds with the `<keep>number</keep>`.

    This parameter also works with the existing (no -c) mode and
    applies to the number of items kept in the cache.

    The default for keep is 5.

9. To help identify builds on the scoreboard there is a "Build
    Sponsor" column.  This consists of two parts the name of the
    sponsor defined by `<build_sponsor>` name `</build_sponsor>` and
    a url defined by `<build_sponsor_url>` url `</build_sponsor_url>`
    that would be displayed when the name is clicked.

10. To optimize the speed of scoreboard generation and (greatly)
     decrease diskspace requirements one could use the -b option.
     When specified the scoreboard script will not create local
     cache copies of build logfiles (raw and prettified) but
     will use build URL based links throughout *unless* a build
     configuration explicitly specifies that the local cache must
     be used through the definition of a `<cache/>` tag in the
     `<build>` section for that build.

USING Cygwin on Windows
=======================

On Windows we need to have access to several unix like tools, the
easiest is to use Cygwin. The following steps describe how to obtain
Cygwin and install it.

* Go to www.cygwin.com and download the setup.exe from the page and
  install it on the desktop

* Start setup.exe from the desktop, press next, another time next, root
  directory is ok by default, change local package directory to
  c:\cygwin\download, select how to connect to the internet, select a
  download site in your area. Now the package selection is shown, press
  the view button once, besides the default packages also select cvs,
  openssh, rsync and svn and then press next to install everything.
  Let the installer create the desktop icon.

* Start cygwin using the desktop icon and do a ssh to another server and
  close the cygwin shell again. Then copy the ssh keys from another system
  to `c:\cygwin\home\<user>\.ssh`.

* For perl we prefer active state perl from www.activestate.com

* Then have a look at other build files how to setup a config file.

MISCELLANEOUS NOTES
===================

1. check_compiler  ->  print out the version of the compiler being used, for example:

         <command name="check_compiler" options="gcc" />

    The values which can be specified in the options field are in
    the Run() method of autobuild/command/check_compiler.pm

2. configs  ->  Specify a special configuration for auto_run_tests.pl, for example:

         <variable name="configs"  value="Linux ST" />

   Will invoke: auto_run_tests.pl -Config Linux -Config ST

3. print_os_version -> print out some information about the operating system
                        being used for the build

         <command name="print_os_version" />

   If you run on Windows with Cygwin or MingW and you have uname installed
   you can printed os version and uname results with

         <command name="print_os_version" options="useuname" />

4. print_perl_version -> print out some information about the perl version
                          being used for the build

         <command name="print_perl_version" />

5. print_make_version -> print out some information about the make version
                          being used for the build

         <command name="print_make_version" />

E-MAIL NOTIFICATION
===================

Preliminary e-mail notification support has been added.  It is still a work in
progress.  Unix supported only for now, NT support on the way.

1.  Add the following lines to the configuration file:

         <variable name="MAIL_ADMIN"  value="myname@mydomain.com" />
         <variable name="SCOREBOARD_URL"  value="http://mydomain.com/my_scoreboard_url" />

     When build errors are detected, an e-mail will be sent to myname@mydomain.com,
     showing an abbreviated list of errors, and referring the recipient to
     look at SCOREBOARD_URL for a full list of the errors.


     Alternatively, if you would like the build errors to be sent to a group of
     people, use the following line instead of MAIL_ADMIN above:

         <variable name="MAIL_ADMIN_FILE"  value="C:/foo/mail_map.txt" />

     The MAIL_ADMIN_FILE variables point to a file that contains the email addresses
     of people who should notified by email when an error occurs. Note that file
     should have one email address per line.

2.  For Windows NT only, you also need to add the domain name of the SMTP
     server used to send outgoing mail.  You do not need to add this line on
     UNIX platforms:

         <variable name="MAIL_ADMIN_SMTP_HOST"  value="smtphostame.mydomain.com" />

NOTE:
If you'd like to change the email address of autobuild displayed to users who
recieve email notification, add and modifiy the line below:

         <variable name="MAIL_SENDER_ADDRESS"  value="autobuild@mydomain.com" />
