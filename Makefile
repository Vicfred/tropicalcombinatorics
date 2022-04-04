# Makefile from
# https://github.com/mavam/stat-cookbook/blob/master/Makefile
DOC  := tropical.tex

RERUN := "(undefined references|Rerun to get (cross-references|the bars|point totals) right|Table widths have changed. Rerun LaTeX.|Linenumber reference failed)"
RERUNBIB := "No file.*\.bbl|Citation.*undefined"

all: figs doc

figs:
	@$(MAKE) -C $@

doc: $(DOC:.tex=.pdf)

%.pdf: %.tex
	lualatex $<
	@egrep -q $(RERUNBIB) $*.log && bibtex $* && lualatex $<; true
	@egrep -q $(RERUN) $*.log && lualatex $<; true
	@egrep -q $(RERUN) $*.log && lualatex $<; true

latexmk:
	-latexmk -pvc -pdf $(DOC)

purge:
	-rm -f *.{aux,dvi,log,bbl,blg,brf,fls,toc,thm,out,fdb_latexmk,pdf}

clean: purge
	$(MAKE) -C figs $@
	-rm -f $(DOC:.tex=.pdf)

.PHONY: all figs purge clean
