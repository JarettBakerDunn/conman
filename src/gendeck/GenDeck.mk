#
# Makefile for program to generate ConMan input decks.
#

PROGRAM= GenDeck
DESTDIR= $(CONBIN)
MAIN= gendeck.f
SUBS=  \
	corner.f \
	exist.f \
	getint.f \
	gtreal.f \
	kblnk.f \
	nblen.f \
	skpsec.f \
	velbcf.f \
	yes.f

SOURCES= $(MAIN) $(SUBS)

#FFLAGS= -O -extend_source
FFLAGS=  -extend_source
#FC= $(F77)
FC = ifort
#FFLAGS = 

OBJECTS= $(SOURCES:.f=.o)
DEBUG= $(PROGRAM:%=debug/%)
VARIANTS.o= $(OBJECTS)

.KEEP_STATE:
.INIT:
	-mkdir debug

all: $(PROGRAM)
debug: $(DEBUG)

$(DEBUG) := FFLAGS= -g
$(DEBUG) := VARIANTS.o= $(OBJECTS:%=debug/%)

$(PROGRAM) $(DEBUG): $(VARIANTS.o)
	$(LINK.f) -o $@ $(VARIANTS.o)

debug/%.o: %.f
	$(COMPILE.f) -o $@ $<

install: $(PROGRAM)
	mv -f $(PROGRAM) $(DESTDIR)
	rm -r debug

test: $(PROGRAM)
	mv -f $(PROGRAM) $(DESTDIR)/$(PROGRAM).test

clean:
	rm -r $(PROGRAM) $(OBJECTS) debug
