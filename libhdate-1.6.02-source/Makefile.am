## Process this file with automake to produce Makefile.in

PACKAGE_NAME = libhdate
PACKAGE_STRING = library for Hebrew date information
PACKAGE_TARNAME = 
PACKAGE_URL = libhdate.sourceforge.net
PACKAGE_VERSION = 1.6.02
VERSION = 1.6.02

SUBDIRS = po docs src examples bindings

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libhdate.pc

libhdate_CFLAGS = -Wall -g -Wformat -Wformat-security -Werror=format-security -D_FORTIFY_SOURCE=2 -O1 -fstack-protector --param ssp-buffer-size=4 -fPIE -pie
libhdate_LDFLAGS = -z relro -z now


libhdatedocdir = ${prefix}/share/doc/libhdate
libhdatedoc_DATA = \
	README\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS\
	USE \
	ABOUT-NLS 

EXTRA_DIST = $(libhdatedoc_DATA) libhdate.pc.in

ACLOCAL_AMFLAGS = -I m4
