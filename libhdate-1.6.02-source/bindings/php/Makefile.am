
EXTRA_DIST = hdate.i hdate.ini

if WITH_PHP

DEPS= $(top_builddir)/src/libhdate.la

CLEANFILES = *.o *.cpp *.h *.so *.php *wrap*

all-am: hdate.so
	

hdate.so: hdate_wrap.cpp
	g++ -I$(top_srcdir)/src `php-config --includes` -fpic -c hdate_wrap.cpp
	gcc -shared ../../src/.libs/libhdate.so hdate_wrap.o -lstdc++ -o hdate.so

hdate_wrap.cpp: hdate.i
	swig -php5 -c++ hdate.i

install-data-local: hdate.so hdate.ini hdate.php
	$(mkinstalldirs) $(DESTDIR)$(PH_MODULES_PATH)
	$(INSTALL_DATA) hdate.so $(DESTDIR)$(PH_MODULES_PATH)/hdate.so
	
	$(mkinstalldirs) $(DESTDIR)$(PH_CONFIG_PATH)
	$(INSTALL_DATA) hdate.ini $(DESTDIR)$(PH_CONFIG_PATH)/hdate.ini
	
	$(mkinstalldirs) $(DESTDIR)$(PH_INCLUDE_PATH)
	$(INSTALL_DATA) hdate.php $(DESTDIR)$(PH_INCLUDE_PATH)/hdate.php
endif
