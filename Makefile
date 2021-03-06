NAME  = how-to-license-data
BIB   = license-data
SHELL = bash
all: pdf html clean
	exit 0
tmp: $(NAME).md
	cp $(NAME).md $(NAME)-tmp.md
	echo -e "\n# Notes {#sec:notes}\n\nBefore uploading to the DCC website, the order of the last three items should be reversed, i.e. 'Notes', then 'Further information', then 'Acknowledgements'.\n\n" >> $(NAME)-tmp.md
	perl -0777 -p -i -e 's@\\bgroup\\boxout@<div class="div_highlight" style="border-radius:8px;">@ig' $(NAME)-tmp.md
	perl -0777 -p -i -e 's@\\endboxout\\egroup@</div>@ig' $(NAME)-tmp.md
	perl -0777 -p -i -e 's@\\(end)?fillboxout@@ig' $(NAME)-tmp.md
pdf: tmp $(BIB).bib dcchowto-apa.csl
	# The next line is peculiar to this document
	perl -0777 -p -i -e 's@\\footref\(fn:valimiki\)@\\footref{fn:valimiki}@ig' $(NAME)-tmp.md
	pandoc -s -S --latex-engine=lualatex --bibliography=$(BIB).bib --csl dcchowto-apa.csl -N -V fontsize=11pt -V papersize=a4paper -V lang=british -V geometry:hmargin=3cm -V geometry:vmargin=2.5cm -V mainfont=Charis\ SIL -V monofont=DejaVu\ Sans\ Mono -V documentclass=memoir -V classoption="article,oneside" -V header-includes="\usepackage[svgnames]{xcolor}\colorlet{dccblue}{Blue}\colorlet{dccmaroon}{Crimson}\colorlet{dccpeach}{AntiqueWhite}\colorlet{shadecolor}{AntiqueWhite}\usepackage{tikz}\usetikzlibrary{positioning}\let\marginfigure=\figure\let\endmarginfigure=\endfigure\newfloat{marginbox}{lom}{Box}\let\quotefrom=\relax\let\finalpage=\relax\let\fullwidth=\relax\let\endfullwidth=\relax\let\fullcite=\textbf" $(NAME)-tmp.md -o $(NAME)-preview.pdf
html: tmp $(BIB).bib dcchowto-apa.csl
	perl -0777 -p -i -e 's@\\bgroup\\figure(?:\[[^\]]+\])?(.*?)\\caption\[[^\]]+\]\{([^}]+)\}\n\\label\{([^}]+)\}\n\n\\endfigure\\egroup@<div class="div_highlight" style="border-radius:8px;" id="\3">\1<p style="text-align:center;"><strong>Figure N:</strong> \2</p>\n\n</div>@igms' $(NAME)-tmp.md
	perl -0777 -p -i -e 's@\\bgroup\\figure(?:\[[^\]]+\])?(.*?)\\caption\{([^}]+)\}\n\\label\{([^}]+)\}\n\n\\endfigure\\egroup@<div class="div_highlight" style="border-radius:8px;" id="\3">\1<p style="text-align:center;"><strong>Figure N:</strong> \2</p>\n\n</div>@igms' $(NAME)-tmp.md
	perl -0777 -p -i -e 's|<strong>Figure N:</strong>|<strong>Figure @{[++$$a]}:</strong>|ig' $(NAME)-tmp.md
	perl -0777 -p -i -e 's@\\input\{([^}]+)\}@open+F,"$$1.html";join"",<F>@ige' $(NAME)-tmp.md
	# The next line is peculiar to this document
	perl -0777 -p -i -e 's@\\footref\(fn:valimiki\)@<a href="#fn55" class="footnoteRef"><sup>[55]</sup></a>@ig' $(NAME)-tmp.md
	pandoc -s -S --toc --toc-depth=1 --bibliography=$(BIB).bib --csl dcchowto-apa.csl --template=`kpsewhich dcchowto-template.html` $(NAME)-tmp.md -o $(NAME).html
	perl -0777 -p -i -e 's@<p></p>@@ig' $(NAME).html
	perl -0777 -p -i -e 's@<h5 id="([^"]+)">(?:<a href="[^"]+">)?([^<]+)(?:</a>)?</h5>@<h6 id="\1">\2</h6>@ig' $(NAME).html
	perl -0777 -p -i -e 's@<h4 id="([^"]+)">(?:<a href="[^"]+">)?([^<]+)(?:</a>)?</h4>@<h5 id="\1">\2</h5>@ig' $(NAME).html
	perl -0777 -p -i -e 's@<h3 id="([^"]+)">(?:<a href="[^"]+">)?([^<]+)(?:</a>)?</h3>@<h4 id="\1">\2</h4>@ig' $(NAME).html
	perl -0777 -p -i -e 's@<h2 id="([^"]+)">(?:<a href="[^"]+">)?([^<]+)(?:</a>)?</h2>@<h3 id="\1">\2</h3>@ig' $(NAME).html
	perl -0777 -p -i -e 's@<h1 id="([^"]+)">(?:<a href="[^"]+">)?([^<]+)(?:</a>)?</h1>@<p class="back"><a href="#top"><img alt="Back to top" class="mceItem" height="16" src="http://www.dcc.ac.uk//sites/all/themes/dcc/images/arrow_up.png" title="Back to top" width="16" /></a></p>\n<h2 id="\1">\2</h2>@ig' $(NAME).html
	perl -0777 -p -i -e 's@<div class="div_highlight" style="border-radius:8px;">\n<h1><a href="([^"]+)">([^<]+)</a></h1>@<div class="div_highlight" style="border-radius:8px;">\n<h2 id="\1">\2</h2>@ig' $(NAME).html
	perl -0777 -p -i -e 's@<h1><a href="#sec:refs">References</a></h1>@<h2 id="#sec:refs">References</h2>@ig' $(NAME).html
	perl -0777 -p -i -e 's@<sup>(\d+)</sup>@<sup>[\1]</sup>@ig' $(NAME).html
dtp: $(NAME).md $(BIB).bib
	pandoc -s -S --biblatex --bibliography=$(BIB).bib --template=`kpsewhich dcchowto-template.latex` -V header-includes="\usetikzlibrary{positioning}" $(NAME).md -t latex -o $(NAME).tex
	# The next 3 lines are peculiar to this document
	perl -0777 -p -i -e 's@\\footref\(fn:valimiki\)@\\footref{fn:valimiki}@ig' $(NAME).tex
	perl -0777 -p -i -e 's@\\autocite\{valimaki2003dlo\}@\\footnote{\\fullcite{valimaki2003dlo}\\label{fn:valimiki}}@i' $(NAME).tex
	perl -0777 -p -i -e 's/\[\@adobe2010xmp\]/\\autocite{adobe2010xmp}/ig' $(NAME).tex
	# General lines
	perl -0777 -p -i -e 's/\\item\[([^\]]+) \\autocite\{([^}]+)\}\]\n/\\item[\1]\n\\hskip-\\labelsep\\autocite{\2}\\hskip\\labelsep /ig' $(NAME).tex
	perl -0777 -p -i -e 's/\\item\[([^\]]+)\\footnote\{([^\]]+)\}\]\n/\\item[\1]\n\\hskip-\\labelsep\\footnote{\2}\\hskip\\labelsep /ig' $(NAME).tex
	perl -0777 -p -i -e 's@,\sURL:@, \\smallcaps{URL}:@igms' $(NAME).tex
	perl -0777 -p -i -e 's@\\texttt\{\\textless\{\}\}@\$$\\langle\$$@ig' $(NAME).tex
	perl -0777 -p -i -e 's@\\texttt\{\\textgreater\{\}\}@\$$\\rangle\$$@ig' $(NAME).tex
	perl -0777 -p -i -e 's@\\fullcite\{([^}]+)\}\\autocite\{\1\}@\\fullcite{\1}@ig' $(NAME).tex
	latexmk -pdflatex="pdflatex -synctex=1 -interaction batchmode %O %S" -pdf $(NAME).tex
clean:
	rm -f $(NAME).{aux,bbl,bcf,blg,fdb_latexmk,fls,log,out,run.xml,synctex.gz}
	rm -f $(NAME)-tmp.md
distclean: clean
	rm -f $(NAME).{tex,html,pdf} $(NAME)-preview.pdf
