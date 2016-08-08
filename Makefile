PY=python
PANDOC=pandoc

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/src
OUTPUTDIR=$(BASEDIR)/output
TEMPLATEDIR=$(INPUTDIR)/templates
STYLEDIR=$(BASEDIR)/style

BIBFILE=$(INPUTDIR)/references.bib

help:
	@echo ' '
	@echo 'Makefile for the Markdown thesis '
	@echo ' '
	@echo 'Usage:'
	@echo '   make html                                                 generate a web version'
	@echo '   make pdf                                                  generate a PDF file'
	@echo '   make pdf blind=y                                          generate a PDF file for blind review'
	@echo '   make pdf engine=pdflatex                                  generate a PDF with different engine'
	@echo '   make pdf toc=yes                                          generate a PDF file with pandoc toc'
	@echo '   make pdf frontmatter=yes bibstyle=abnt-ABNT               generate a PDF file wit front matter'
	@echo '   make pdf no-draft=y                                       generate a PDF without draft content'
	@echo '   make docx                                                 generate a Docx file'
	@echo '   make tex                                                  generate a Latex file'
	@echo '   make tex frontmatter=yes                                  generate a PDF file with front matter'
	@echo '   make wc                                                   output word count for every .md file under src/body'
	@echo '   make spellcheck                                           checks grammar using languagetool (autodetect language)'
	@echo '   make spellcheck lang=en-GB opts="--disable EN_QUOTES"     checks grammar using language tool with options'
	@echo ''
	@echo ''
	@echo 'Supported citation styles (bibstyle):'
	@echo ''
	@echo 'APA, chicago, MLA, harvard, springer, ABNT (default)'
	@echo ''
	@echo ''
	@echo 'get local templates with: pandoc -D latex/html/etc'
	@echo 'or generic ones from: https://github.com/jgm/pandoc-templates'

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

ifndef engine
  ENGINE = xelatex
else
	ENGINE = $(engine)
endif

ifneq (,$(findstring $(blind),yes-y-on))
	BLIND_REVIEW = "--metadata=blindreview:on"
else
	BLIND_REVIEW = 
endif

ifneq (,$(findstring $(frontmatter),yes-y-on))
  FRONTMATTER = "$(INPUTDIR)/front-matter"/*.md
  DEFAULT_FM =
else
  FRONTMATTER =
  DEFAULT_FM = "--metadata=default_frontmatter=y"
endif

ifndef lang
	LANGUAGE = -adl
else
  LANGUAGE = -l $(lang)
endif

ifndef opts
	OPTS = 
else
	OPTS = $(opts)
endif

ifneq (,$(findstring $(no-draft),yes-y-on))
	BODY = $(shell find $(INPUTDIR)/body -type f -name '*.md' -not -path '*/00-draft.md')
else
  BODY = $(shell find $(INPUTDIR)/body -type f -name '*.md')
endif

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
	--number-sections \
	--filter pandoc-crossref \
	$(BLIND_REVIEW) \
	$(DEFAULT_FM)


ifneq (,$(findstring $(toc),yes-y-on))
  PANDOC_TOC = "--toc"
else
  PANDOC_TOC =
endif

pdf: clean
	pandoc \
	$(BASE_PANDOC_PARAMS) \
	$(PANDOC_TOC) \
	-o "$(OUTPUTDIR)/thesis.pdf" \
	--latex-engine=$(ENGINE) \
	--verbose

tex: clean
	pandoc \
	$(BASE_PANDOC_PARAMS) \
	$(PANDOC_TOC) \
	-o "$(OUTPUTDIR)/thesis.tex" \
	--latex-engine=$(ENGINE)

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

wc:
	@wc -w $(BODY)

spellcheck:
	languagetool $(OPTS) $(LANGUAGE) -r $(INPUTDIR)/body

clean:
	rm -rf $(OUTPUTDIR)
	mkdir $(OUTPUTDIR)

.PHONY: help pdf docx html tex wc spellcheck
