How to License Research Data
============================

The Digital Curation Centre (DCC) is a centre of expertise in digital
information curation, with a focus on research data management. Among its
activities is the publication of How-to Guides that provide working knowledge of
curation topics. The guides are aimed at people in research or support posts who
are new to managing and curating data.

"How to License Research Data" is a title in this series. Before moving to this
repository, there were five versions:

 1. 2011-02-22
 2. 2011-06-01
 3. 2011-10-18
 4. 2012-06-20
 5. 2014-01-17

Future maintenance of the Guide will occur in this repository.

Branching policy
----------------

There are two main branches in use:

  * **master** contains versions from the initial migration, versions for
    review and QA (tags r6.1, r6.2...) and released versions (tags v5, v6...).
  * **revision** is the working branch where the document is revised.


Authoring convention
--------------------

The document is written in the flavour of Markdown used by
[Pandoc](http://johnmacfarlane.net/pandoc/) to make it easy to generate
alternative formats.

The references are generated from the bibliographic information in the
`license-data.bib` file, which is written in
[biblatex](http://www.tex.ac.uk/tex-archive/help/Catalogue/entries/biblatex.html)
format.


Compiling the document
----------------------

While the document is mostly readable [as it
is](https://github.com/alex-ball/HowTo-LicenseData/blob/master/how-to-license-data.md),
it contains some additional publication-related markup that may cause problems.
If you have Pandoc and pandoc-citeproc installed, and a copy of
[apa.csl](https://raw.githubusercontent.com/citation-style-language/styles/master/apa.csl)
to hand, you can generate somewhat more presentable versions of the document.

For HTML:

~~~~
pandoc -s -S --biblio license-data.bib --csl apa.csl how-to-license-data.md -o how-to-license-data.html
~~~~

For MS Office:

~~~~
pandoc -S --biblio license-data.bib --csl apa.csl how-to-license-data.md -o how-to-license-data.docx
~~~~

For PDF, you will also need to have a TeX distribution installed. The command to
pass will be different depending on your exact set up, but at the very least you will need to inject some extra code to get it to compile properly. Here's an example that
uses LuaLaTeX as the engine, and Charis SIL and DejaVu Sans Mono as the fonts; the parts you might want to change start with the `fontsize` option:

~~~~
pandoc -s -S -V documentclass=memoir -V classoption="article,oneside" -V header-includes="\usepackage[svgnames]{xcolor}\colorlet{dccblue}{Blue}\colorlet{dccmaroon}{Crimson}\colorlet{dccpeach}{AntiqueWhite}\colorlet{shadecolor}{AntiqueWhite}\usepackage{tikz}\usetikzlibrary{positioning}\let\marginfigure=\figure\let\endmarginfigure=\endfigure\newfloat{marginbox}{lom}{Box}\let\quotefrom=\relax\let\finalpage=\relax\let\fullwidth=\relax\let\endfullwidth=\relax\let\fullcite=\textbf" --biblio license-data.bib --csl apa.csl -V fontsize=11pt -V papersize=a4paper -V lang=british -V geometry:hmargin=3cm -V geometry:vmargin=2.5cm --latex-engine=lualatex -V mainfont="Charis SIL" -V monofont="DejaVu Sans Mono" how-to-license-data.md -o how-to-license-data-preview.pdf
~~~~

Getting the best results involves a bit of tweaking. These tweaks are set out in the included Makefile. You could execute them manually, but it is far more convenient to let your computer do it for you, in which case you will also need to have the following installed:

* the Make utility
* Perl
* the aforementioned fonts [Charis SIL](http://scripts.sil.org/cms/scripts/page.php?item_id=CharisSIL_download) and [DejaVu Sans Mono](http://dejavu-fonts.org/wiki/Download) (for preview PDF output, though you could choose different ones by editing the Makefile)

To generate both HTML and a preview PDF, simply run this command:

~~~~
make
~~~~

For just the HTML:

~~~~
make html
~~~~

For just the PDF:

~~~~
make pdf
~~~~

To clean up the auxiliary files:

~~~~
make clean
~~~~

To remove all generated files:

~~~~
make distclean
~~~~

For a camera-ready PDF such as the DCC publishes, you will need the class file `dcchowto.cls`. Currently the only way of getting it is to generate it from the [`dcchowto` DTX file](https://github.com/alex-ball/dcchowto). Having done that, and either installed it to your TeX tree or added a copy to your working directory, you should be able to compile the document like this:

~~~~
make dtp
~~~~
