.PHONY: hedpc_natphys bibtex

hedpc_natphys: hedpc_natphys.tex
	latex $@
	latex $@
	dvips $@.dvi
	ps2pdf $@.ps

bibtex: hedpc_natphys.tex 
	rm *.aux
	latex hedpc_natphys
	bibtex hedpc_natphys
	latex hedpc_natphys
	latex hedpc_natphys
	dvips hedpc_natphys.dvi
	ps2pdf hedpc_natphys.ps

point_by_point_response.pdf: point_by_point_response.tex
	pdflatex $^
	pdflatex $^

appeal_letter.pdf: appeal_letter.tex
	pdflatex $^
	pdflatex $^

clean:
	-rm *.aux *.bbl *.blg *.dvi *.log *.ps *.backup
