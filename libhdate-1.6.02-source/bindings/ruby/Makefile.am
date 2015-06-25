
EXTRA_DIST = hdate.i

if WITH_RUBY

DEPS= $(top_builddir)/src/libhdate.la

CLEANFILES = *.o *.cxx *.so *wrap*

all-am: hdate.so
	

hdate.so: hdate_wrap.cxx
	g++ -fpic -fno-strict-aliasing -g -O2 -c hdate_wrap.cxx $(RU_CFLAGS) -I$(top_srcdir)/src
	gcc -shared ../../src/.libs/libhdate.so hdate_wrap.o -rdynamic -Wl,-export-dynamic -lruby$(RU_VERSION) -lpthread -ldl -lcrypt -lm -lc -lstdc++ -o hdate.so

hdate_wrap.cxx: hdate.i
	swig -c++ -ruby hdate.i

install-data-local: hdate.so
	$(mkinstalldirs) $(DESTDIR)$(RU_MODULES_PATH)
	$(INSTALL_DATA) hdate.so $(DESTDIR)$(RU_MODULES_PATH)/hdate.so

endif
