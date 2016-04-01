PY=python
PANDOC=pandoc

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/source
OUTPUTDIR=$(BASEDIR)/output
TEMPLATEDIR=$(INPUTDIR)/templates
STYLEDIR=$(BASEDIR)/style

BIBFILE=$(INPUTDIR)/references.bib

help:
	@echo ' 																	    '
	@echo 'Makefile for the Markdown thesis                                         '
	@echo '                                                                         '
	@echo 'Usage:                                                                   '
	@echo '   make html                        generate a web version               '
	@echo '   make pdf                         generate a PDF file  			    '
	@echo '   make pdf include-frontmatter=yes generate a PDF file with front matter'
	@echo '   make docx	                       generate a Docx file 			    '
	@echo '   make tex	                       generate a Latex file 			    '
	@echo '   make tex include-frontmatter=yes generate a PDF file with front matter'
	@echo '                                                                         '
	@echo ' 																	    '
	@echo ' 																	    '
	@echo 'get local templates with: pandoc -D latex/html/etc	  				    '
	@echo 'or generic ones from: https://github.com/jgm/pandoc-templates		    '

ifneq (,$(findstring $(include-frontmatter),yes-y-on))
  FRONTMATTER = "$(INPUTDIR)/front-matter"/*.md
else
  FRONTMATTER = 
endif

BODY = $(shell find $(INPUTDIR)/body -type f -name '*.md')
ENDMATTER = "$(INPUTDIR)/end-matter"/*.md

PATHS = $(FRONTMATTER) \
	$(BODY) \
	$(ENDMATTER) \
	$(INPUTDIR)/config.yaml


BASE_PANDOC_PARAMS = $(PATHS) \
	-H "$(STYLEDIR)/preamble.tex" \
	--template="$(STYLEDIR)/template.tex" \
	--bibliography="$(BIBFILE)" 2>pandoc.log \
	--csl="$(STYLEDIR)/ref_format.csl" \
	--highlight-style pygments \
	-V documentclass:report \
	-N \
	--filter pandoc-crossref

ifneq (,$(findstring $(include-frontmatter),yes-y-on))
  PANDOC_TOC = 
else
  PANDOC_TOC = "--toc"
endif

pdf: clean
	pandoc \
	$(BASE_PANDOC_PARAMS) \
	$(PANDOC_TOC) \
	-o "$(OUTPUTDIR)/thesis.pdf" \
	--latex-engine=xelatex \
	--verbose

tex: clean
	pandoc \
	$(BASE_PANDOC_PARAMS) \
	$(PANDOC_TOC) \
	-o "$(OUTPUTDIR)/thesis.tex" \
	--latex-engine=xelatex

docx: clean
	pandoc \
	$(BASE_PANDOC_PARAMS) \
	$(PANDOC_DOC) \
	-o "$(OUTPUTDIR)/thesis.docx" \
	--toc

html:
	pandoc \
	$(BASE_PANDOC_PARAMS) \
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
