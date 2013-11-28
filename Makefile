.PHONY: bibtex prepare_for_bibtex cleanup_bibtex no_bibtex

VERSION=$(shell git describe --always --abbrev=4)

all: hedpc.pdf

hedpc.pdf: hedpc.tex library.bib
	make prepare_for_bibtex
	make bibtex
	make cleanup_bibtex
	make no_bibtex

no_bibtex: hedpc.tex
	latex $<
	latex $<
	dvips $(addsuffix .dvi, $(basename $<))
	ps2pdf $(addsuffix .ps, $(basename $<))
	exiftool -overwrite_original -Subject="$(VERSION)" $(addsuffix .pdf, $(basename $<))

prepare_for_bibtex: hedpc.tex library.bib
	sed -i '/bibliographystyle/s/%//g' $<
	sed -i '/bibliography{library}/s/%//g' $<
	sed -i '/merlin/,/end{thebib/d' $<

cleanup_bibtex: hedpc.tex library.bib
	sed -i '/bibliographystyle/s/^/%/' $<
	sed -i '/bibliography{library}/s/^/%/' $<
	sed -i '/bibliography{library}/r $(addsuffix .bbl, $(basename $<))' $<

bibtex: hedpc.tex 
	latex hedpc
	bibtex hedpc
	latex hedpc
	latex hedpc
	dvips hedpc.dvi
	ps2pdf hedpc.ps
	exiftool -overwrite_original -Subject="$(VERSION)" $(addsuffix .pdf, $(basename $<))

clean:
	-rm -f *.aux *.bbl *.blg *.dvi *.log *.ps *.backup
