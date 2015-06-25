// file : hdate.i
%module hdate
%{
#include "../../src/hdatepp.h"
%}

%include ../../src/hdatepp.h

// on linux do:
// swig -python hdate.i
// g++ -fpic -c hdate_wrap.cxx -I/usr/include/python2.3
// g++ -shared ../../src/*.o hdate_wrap.o -o _hdate.so
