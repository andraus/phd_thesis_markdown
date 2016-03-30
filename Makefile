PY=python
PANDOC=pandoc

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/source
OUTPUTDIR=$(BASEDIR)/output
TEMPLATEDIR=$(INPUTDIR)/templates
STYLEDIR=$(BASEDIR)/style

BIBFILE=$(INPUTDIR)/references.bib

help:
	@echo ' 																	  '
	@echo 'Makefile for the Markdown thesis                                       '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make html                        generate a web version             '
	@echo '   make pdf                         generate a PDF file  			  '
	@echo '   make docx	                       generate a Docx file 			  '
	@echo '   make tex	                       generate a Latex file 			  '
	@echo '                                                                       '
	@echo ' 																	  '
	@echo ' 																	  '
	@echo 'get local templates with: pandoc -D latex/html/etc	  				  '
	@echo 'or generic ones from: https://github.com/jgm/pandoc-templates		  '

PATHSOLD =	"$(INPUTDIR)/front-matter"/*.md \
	"$(INPUTDIR)"/*.md \
	"$(INPUTDIR)/end-matter"/*.md \
	"$(INPUTDIR)"/config.yaml

FRONTMATTER = "$(INPUTDIR)/front-matter"/*.md
BODY = $(shell find $(INPUTDIR)/body -type f -name '*.md')
ENDMATTER = "$(INPUTDIR)/end-matter"/*.md

PATHS = $(FRONTMATTER) \
	$(BODY) \
	$(ENDMATTER) \
	$(INPUTDIR)/config.yaml

pdf: clean
	pandoc \
	$(PATHS) \
	-o "$(OUTPUTDIR)/thesis.pdf" \
	-H "$(STYLEDIR)/preamble.tex" \
	--template="$(STYLEDIR)/template.tex" \
	--bibliography="$(BIBFILE)" 2>pandoc.log \
	--csl="$(STYLEDIR)/ref_format.csl" \
	--highlight-style pygments \
	-V documentclass:report \
	-N \
	--filter pandoc-crossref \
	--latex-engine=xelatex \
	--verbose

tex: clean
	pandoc $(PATHS) \
	-o "$(OUTPUTDIR)/thesis.tex" \
	-H "$(STYLEDIR)/preamble.tex" \
	--bibliography="$(BIBFILE)" \
	-V documentclass:report \
	-N \
	--csl="$(STYLEDIR)/ref_format.csl" \
	--filter pandoc-crossref \
	--latex-engine=xelatex

docx: clean
	pandoc $(PATHS) \
	-o "$(OUTPUTDIR)/thesis.docx" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLEDIR)/ref_format.csl" \
	--toc

html:
	pandoc $(PATHS) \
	-o "$(OUTPUTDIR)/thesis.html" \
	--standalone \
	--template="$(STYLEDIR)/template.html" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLEDIR)/ref_format.csl" \
	--include-in-header="$(STYLEDIR)/style.css" \
	--toc \
	--number-sections
	rm -rf "$(OUTPUTDIR)/source"
	mkdir "$(OUTPUTDIR)/source"
	cp -r "$(INPUTDIR)/figures" "$(OUTPUTDIR)/source/figures"

clean:
	rm -rf $(OUTPUTDIR)
	mkdir $(OUTPUTDIR)

.PHONY: help pdf docx html tex
