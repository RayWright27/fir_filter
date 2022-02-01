SYSTEM_ARCH=linux64
#or linux for 32 bit machines
SYSTEMC_HOME=/usr/local/systemc-2.3.1/
LIB_DIRS=$(SYSTEMC_HOME)/lib-linux64 
#а не SYSTEMC_HOME?

#include directories
INCLUDE_DIRS= -I. -I$(SYSTEMC_HOME)/include

#header files для dependency checking
HEADERS= fir.h tb.h

DEPENDENCIES= Makefile $(HEADERS) $(SOURCES)

LIBS= -lsystemc -lstdc++ -lm 

SOURCES = main.cpp fir.cpp tb.cpp 

DEPENDENCIES = \
		Makefile \
		$(HEADERS) \
		$(SOURCES)

LIBS= -lsystemc -lm

LDFLAGS= -Wl,-rpath=$(SYSTEMC_HOME)/lib-$(SYSTEM_ARCH)

TESTS= main

all: $(TESTS)
		./$(TESTS)
		 @make cmp_result

$(TESTS): $(DEPENDENCIES)
		g++ -o $@ $(SOURCES) $(INCLUDE_DIRS) -L$(LIB_DIRS) $(LIBS) $(LDFLAGS)


#HINT: tokens, following the ":" on the same line as the target are dependencies of that target. The command must be on the NEXT LINE, preceded by a TAB!!!
clean: 
	rm -f $(TESTS) *.dat

GOLD_DIR=./golden
GOLD_FILE=$(GOLD_DIR)/ref_output.dat

cmp_result:
	@echo "******************************"
	@if diff -w $(GOLD_FILE) ./ref_output.dat; then echo "SUCCESS";\
	else echo "FAIL"; fi
	@echo "*******************************"
