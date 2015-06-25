
EXTRA_DIST = Package.fpc hdate.pp hdate_dyn_pascal.pp fpc_README changelog

if WITH_GPC_FPC

DEPS= $(top_builddir)/src/libhdate.la

CLEANFILES = *.o *.ppu *.gpi

all-am: hdate.o hdate_dyn_pascal.o hdate.gpi

hdate.o: hdate.pp
	fpc hdate.pp

hdate_dyn_pascal.o: hdate_dyn_pascal.pp hdate.o
	fpc hdate_dyn_pascal.pp

hdate.gpi: hdate.pp
	gpc --interface-only hdate.pp

install-data-local:hdate_dyn_pascal.o hdate.o
	$(mkinstalldirs) $(DESTDIR)$(PA_MODULES_PATH)/hdate
	$(INSTALL_DATA) hdate.o $(DESTDIR)$(PA_MODULES_PATH)/hdate/hdate.o
	$(INSTALL_DATA) hdate_dyn_pascal.o $(DESTDIR)$(PA_MODULES_PATH)/hdate/hdate_dyn_pascal.o
	$(INSTALL_DATA) hdate.ppu $(DESTDIR)$(PA_MODULES_PATH)/hdate/hdate.ppu
	$(INSTALL_DATA) hdate_dyn_pascal.ppu $(DESTDIR)$(PA_MODULES_PATH)/hdate/hdate_dyn_pascal.ppu
	$(INSTALL_DATA) fpc_README $(DESTDIR)$(PA_MODULES_PATH)/hdate/fpc_README
	$(INSTALL_DATA) Package.fpc $(DESTDIR)$(PA_MODULES_PATH)/hdate/Package.fpc
	$(mkinstalldirs) $(DESTDIR)$(GP_MODULES_PATH)units
	$(INSTALL_DATA) hdate.gpi $(DESTDIR)$(GP_MODULES_PATH)units/hdate.gpi
	$(INSTALL_DATA) hdate.pp $(DESTDIR)$(GP_MODULES_PATH)units/hdate.pas

endif

if WITH_FPC

DEPS= $(top_builddir)/src/libhdate.la

CLEANFILES = *.o *.ppu

all-am: hdate.o hdate_dyn_pascal.o

hdate.o: hdate.pp
	fpc hdate.pp

hdate_dyn_pascal.o: hdate_dyn_pascal.pp hdate.o
	fpc hdate_dyn_pascal.pp

install-data-local:hdate_dyn_pascal.o hdate.o
	$(mkinstalldirs) $(DESTDIR)$(PA_MODULES_PATH)/hdate
	$(INSTALL_DATA) hdate.o $(DESTDIR)$(PA_MODULES_PATH)/hdate/hdate.o
	$(INSTALL_DATA) hdate_dyn_pascal.o $(DESTDIR)$(PA_MODULES_PATH)/hdate/hdate_dyn_pascal.o
	$(INSTALL_DATA) hdate.ppu $(DESTDIR)$(PA_MODULES_PATH)/hdate/hdate.ppu
	$(INSTALL_DATA) hdate_dyn_pascal.ppu $(DESTDIR)$(PA_MODULES_PATH)/hdate/hdate_dyn_pascal.ppu
	$(INSTALL_DATA) fpc_README $(DESTDIR)$(PA_MODULES_PATH)/hdate/fpc_README
	$(INSTALL_DATA) Package.fpc $(DESTDIR)$(PA_MODULES_PATH)/hdate/Package.fpc

endif

if WITH_GPC

DEPS= $(top_builddir)/src/libhdate.la

CLEANFILES = *.gpi *.o

all-am: hdate.gpi

hdate.gpi: hdate.pp
	gpc --interface-only hdate.pp

install-data-local:hdate.gpi
	$(mkinstalldirs) $(DESTDIR)$(GP_MODULES_PATH)units
	$(INSTALL_DATA) hdate.gpi $(DESTDIR)$(GP_MODULES_PATH)units/hdate.gpi
	$(INSTALL_DATA) hdate.pp $(DESTDIR)$(GP_MODULES_PATH)units/hdate.pas
  
endif
