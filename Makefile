# Rolf Niepraschk, 2022-09-22, Rolf.Niepraschk@gmx.de

.SUFFIXES : .tex .ltx .dvi .ps .pdf .eps

MAIN = blowup

LATEX = pdflatex
TEX = tex

VERSION = $(shell awk '/ProvidesPackage/ {print $$2}' $(MAIN).sty)

EXAMPLES = blowup-ex1.tex blowup-ex2.tex blowup-ex3.tex blowup-ex4.tex \
  blowup-ex5.tex blowup-ex6.tex
EXAMPLES_PDF = $(EXAMPLES:.tex=.pdf) 
DIST_DIR = $(MAIN)
DIST_FILES = README.md $(MAIN).dtx $(MAIN).ins $(MAIN).pdf \
  $(EXAMPLES) $(EXAMPLES_PDF)
  
ARCHNAME = $(MAIN)-$(VERSION).zip

all : $(MAIN).pdf $(EXAMPLES_PDF)

$(MAIN).pdf : $(MAIN).dtx $(MAIN).sty
	$(LATEX) $<
	if ! test -f $(basename $<).glo ; then touch $(basename $<).glo; fi
	if ! test -f $(basename $<).idx ; then touch $(basename $<).idx; fi
	makeindex -s gglo.ist -t $(basename $<).glg -o $(basename $<).gls \
		$(basename $<).glo
	makeindex -s gind.ist -t $(basename $<).ilg -o $(basename $<).ind \
		$(basename $<).idx
	$(LATEX) $<
	$(LATEX) $<


$(MAIN).sty : $(MAIN).ins $(MAIN).dtx 
	$(TEX) $<

$(MAIN)-ex%.pdf : $(MAIN)-ex%.tex $(MAIN).sty
	$(LATEX) $< 

dist : $(DIST_FILES)
	rm -rf $(DIST_DIR) $(ARCHNAME)
	mkdir -p $(DIST_DIR)
	cp -p $+ $(DIST_DIR)
	zip $(ARCHNAME) -r $(DIST_DIR)
	rm -rf $(DIST_DIR)

clean :
	$(RM) $(MAIN).sty $(MAIN).pdf $(EXAMPLES_PDF)

debug :
	@echo "----------------------------------"
	@echo $(VERSION)
	@echo $(ARCHNAME)
	@echo $(EXAMPLES)
	@echo $(EXAMPLES_PDF)
	@echo "----------------------------------"



