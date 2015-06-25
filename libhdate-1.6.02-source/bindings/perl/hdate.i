// file : hdate.i
%module hdate
%{
#include "../../src/hdatepp.h"
%}

%include ../../src/hdatepp.h

// on linux do:
// swig -perl hdate.i
// g++ -fpic -c hdate_wrap.cxx -I/usr/lib/perl5/5.8.6/i686-linux/CORE/
// g++ -shared ../../src/*.o hdate_wrap.o -o _hdate.so
