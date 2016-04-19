PY=python
PANDOC=pandoc

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/src
OUTPUTDIR=$(BASEDIR)/output
TEMPLATEDIR=$(INPUTDIR)/templates
STYLEDIR=$(BASEDIR)/style

BIBFILE=$(INPUTDIR)/references.bib

help:
	@echo ' 																	    						 '
	@echo 'Makefile for the Markdown thesis                                         						 '
	@echo '                                                                         						 '
	@echo 'Usage:                                                                   						 '
	@echo '   make html                        							generate a web version  			 '
	@echo '   make pdf                         							generate a PDF file  			     '
	@echo '   make pdf pandoc-toc=yes                        			generate a PDF file with pandoc toc  '
	@echo '   make pdf custom-frontmatter=yes bibstyle=abnt-ABNT			generate a PDF file wit front matter '
	@echo '   make docx	                       							generate a Docx file 			     '
	@echo '   make tex	                       							generate a Latex file 			     '
	@echo '   make tex custom-frontmatter=yes 								generate a PDF file with front matter'
	@echo '                                                                         						 '
	@echo '																									 '
	@echo 'Supported citation styles (bibstyle): 															 '
	@echo '																									 '
	@echo 'APA, chicago, MLA, harvard, springer, ABNT (default)											     '
	@echo ' 																	    						 '
	@echo ' 																	    						 '
	@echo 'get local templates with: pandoc -D latex/html/etc	  				    						 '
	@echo 'or generic ones from: https://github.com/jgm/pandoc-templates		    						 '

ifneq (,$(findstring $(bibstyle),default))
  CSL = $(STYLEDIR)/csl/ref_format.csl
else ifneq (,$(findstring $(bibstyle),APA-apa))
  CSL = $(STYLEDIR)/csl/apa.csl
else ifneq (,$(findstring $(bibstyle),chicago))
  CSL = $(STYLEDIR)/csl/chicago-annotated-bibliography.csl
else ifneq (,$(findstring $(bibstyle),mla-MLA))
  CSL = $(STYLEDIR)/csl/modern-language-association-with-url.csl
else ifneq (,$(findstring $(bibstyle),harvard))
  CSL = $(STYLEDIR)/csl/elsevier-harvard.csl
else ifneq (,$(findstring $(bibstyle),springer))
  CSL = $(STYLEDIR)/csl/springer-basic-author-date.csl
else ifneq (,$(findstring $(bibstyle),abnt-ABNT))
  CSL = $(STYLEDIR)/csl/associacao-brasileira-de-normas-tecnicas.csl
else
  ## default
  CSL = $(STYLEDIR)/csl/associacao-brasileira-de-normas-tecnicas.csl
endif

ifneq (,$(findstring $(custom-frontmatter),yes-y-on))
  FRONTMATTER = "$(INPUTDIR)/front-matter"/*.md
  DEFAULT_FM = 
else
  FRONTMATTER = 
  DEFAULT_FM = "--metadata=default_frontmatter=y"
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
	--csl=$(CSL) \
	--highlight-style pygments \
	-N \
	--filter pandoc-crossref \
	$(DEFAULT_FM)


ifneq (,$(findstring $(pandoc-toc),yes-y-on))
  PANDOC_TOC = "--toc"
else
  PANDOC_TOC = 
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
	$(PANDOC_TOC) \
	--reference-docx template.docx \
	-o "$(OUTPUTDIR)/thesis.docx"

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
	rm -rf "$(OUTPUTDIR)/src"
	mkdir "$(OUTPUTDIR)/src"
	cp -r "$(INPUTDIR)/figures" "$(OUTPUTDIR)/src/figures"

clean:
	rm -rf $(OUTPUTDIR)
	mkdir $(OUTPUTDIR)

.PHONY: help pdf docx html tex
