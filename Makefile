.PHONY: hedpc_natphys bibtex prepare_for_bibtex cleanup_bibtex no_bibtex

VERSION=$(shell git describe --always --abbrev=4)

hedpc_natphys: hedpc_natphys.tex library.bib
	make prepare_for_bibtex
	make bibtex
	make cleanup_bibtex
	make no_bibtex

no_bibtex: hedpc_natphys.tex
	latex $<
	latex $<
	dvips $(addsuffix .dvi, $(basename $<))
	ps2pdf $(addsuffix .ps, $(basename $<))
	exiftool -Subject="$(VERSION)" $(addsuffix .pdf, $(basename $<))

prepare_for_bibtex: hedpc_natphys.tex library.bib
	sed -i '/bibliography{library}/s/%//g' $<
	sed -i '/merlin/,/end{thebib/d' $<

cleanup_bibtex: hedpc_natphys.tex library.bib
	sed -i '/end{document}/d' $<
	sed -i '/bibliography{library}/s/^/%/' $<
	cat $(addsuffix .bbl, $(basename $<)) >> $<
	echo '\\end{document}' >> $<

bibtex: hedpc_natphys.tex 
	latex hedpc_natphys
	bibtex hedpc_natphys
	latex hedpc_natphys
	latex hedpc_natphys
	dvips hedpc_natphys.dvi
	ps2pdf hedpc_natphys.ps
	exiftool -Subject="$(VERSION)" $(addsuffix .pdf, $(basename $<))


point_by_point_response.pdf: point_by_point_response.tex
	pdflatex $<
	pdflatex $<
	exiftool -Subject="$(VERSION)" $@


clean:
	-rm -f *.aux *.bbl *.blg *.dvi *.log *.ps *.backup
