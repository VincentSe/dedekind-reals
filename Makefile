# Based on example given by Adam Chlipala, in “Theorem Proving in the Large”,
# section “Build Patterns”. http://adam.chlipala.net/cpdt/html/Large.html

# Usage examples:
#     make
#     make all
#     make html
#     make clean

# Modules to be included in the main build:
MODULES := \
	MiscLemmas \
	Cut \
	Additive \
	Multiplication \
	MinMax \
	Archimedean \
	Completeness \
	Order \
	Cauchy \
	DecOrder

VS      := $(MODULES:%=%.v)

# The HoTT coq binaries (“hoqc” etc.) are used by default.  These can
# be overridden by explicitly passing a different value of COQC, e.g.
#     make COQC=coqc
# COQDEP and COQDOC are set automatically based on COQC, but we are not
# very clever about this, so if it doesn’t work, these can be explicitly
# specified too.

COQC ?= coqc
COQDEP ?= coqdep
COQDOC ?= coqdoc

export COQC COQDEP COQDOC

# You may specify th elocation of your Coq binaries by setting the environment
# variables COQBIN

COQMAKEFILE = $(COQBIN)coq_makefile

.PHONY: coq all install clean html

coq: Makefile.coq
	$(MAKE) -f Makefile.coq

Makefile.coq: Makefile $(VS)
	$(COQMAKEFILE) -Q . "''" COQC = "$(COQC)" COQDEP = "$(COQDEP)" $(VS) -o Makefile.coq

install: Makefile.coq
	$(MAKE) -f Makefile.coq install

clean:: Makefile.coq
	$(MAKE) -f Makefile.coq clean
	rm -f Makefile*.coq
	rm -f html

cleaner:
	rm -f **/*.glob **/*.vo **/*.v.d **/*~ **/.*.aux

html:: Makefile.coq
	$(MAKE) -f Makefile.coq html
