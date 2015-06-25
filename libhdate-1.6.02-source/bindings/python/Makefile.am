
EXTRA_DIST = hdate.i

if WITH_PYTHON

DEPS= $(top_builddir)/src/libhdate.la

CLEANFILES = *.o *.cxx *.so *wrap* *.py

all-am: _hdate.so
	

_hdate.so: hdate_wrap.cxx
	g++ -fpic -c hdate_wrap.cxx $(PY_CFLAGS) -I$(top_srcdir)/src
	g++ -shared ../../src/.libs/libhdate.so hdate_wrap.o -o _hdate.so

hdate_wrap.cxx: hdate.i
	swig -python -c++ hdate.i

install-data-local: _hdate.so
	$(mkinstalldirs) $(DESTDIR)$(PY_MODULES_PATH)
	$(INSTALL_DATA) _hdate.so $(DESTDIR)$(PY_MODULES_PATH)/_hdate.so
	$(INSTALL_DATA) hdate.py $(DESTDIR)$(PY_MODULES_PATH)/hdate.py

endif
