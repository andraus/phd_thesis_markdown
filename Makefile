PY=python
PANDOC=pandoc

BASEDIR=.
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
	@echo ' '
	@echo '   make pdf                                                  generate a PDF file'
	@echo '   make pdf blind=y                                          generate a PDF file for blind review'
	@echo '   make pdf engine=pdflatex                                  generate a PDF with different engine'
	@echo '   make pdf toc=yes                                          generate a PDF file with pandoc toc'
	@echo '   make pdf frontmatter=yes bibstyle=abnt-ABNT               generate a PDF file wit front matter'
	@echo '   make pdf no-draft=y                                       generate a PDF without draft content'
	@echo '	  make pdf only-chapter=01-chapter'
	@echo '	  make pdf only-section=18'
	@echo '	  make pdf section-in-header=yes                            generate a PDF with section names in headers'
	@echo ' '
	@echo '   make docx                                                 generate a Docx file'
	@echo '   make docx-thesis                                          generate a Docx file using thesis template'
	@echo '   make docx-article                                         generate a Docx file using article template'
	@echo '   make template=<custom> docx                              generate a Docx file using a <custom> template'
	@echo ' '
	@echo '   make tex                                                  generate a Latex file'
	@echo '   make tex frontmatter=yes                                  generate a PDF file with front matter'
	@echo ' '
	@echo '   make epub'
	@echo ' '
	@echo '   make wc                                                   output word count for every .md file under src/body discarding comments'
	@echo '   make wcc                                                  output word count for every .md file under src/body'
	@echo '   make cc                                                   output character count for every .md file under src/body discarding comments'
	@echo '   make ccc                                                  output character count for every .md file under src/body'
	@echo ' '
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

ifdef only-section
  ONLYSECTION = $(only-section)
else ifndef only-chapter
  ONLY_SECTION =
  ONLYCHAPTER =
else
  ONLY_SECTION =
  ONLYCHAPTER = $(only-chapter)
endif

ifneq (,$(findstring $(section-in-header),yes-y-on))
  SECTIONHEADER = $(section-in-header)
else
  SECTIONHEADER =
endif

frontmatter=y
ifneq (,$(findstring $(frontmatter),yes-y-on))
  FRONTMATTER = "$(INPUTDIR)/front-matter"/*.md
  DEFAULT_FM =
	DEFAULT_TOC =
else
  FRONTMATTER =
  DEFAULT_FM = "--metadata=default_frontmatter=y"
	DEFAULT_TOC = "--toc"
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

ifndef template
	TEMPLATE = thesis
else
	TEMPLATE = $(template)
endif

ifneq (,$(findstring $(draft),yes-y-on))
  BODY = $(shell find $(INPUTDIR)/body -type f -name '*.md' | sort)
  else ifdef ONLYSECTION
  	BODY = $(shell find $(INPUTDIR)/body -type f -name '$(ONLYSECTION)*.md' -not -path '*/00-draft.md'| sort)
else ifdef ONLYCHAPTER
	BODY = $(shell find $(INPUTDIR)/body -type f -name '*.md' -path '*/$(ONLYCHAPTER)/*'| sort)
else
	BODY = $(shell find $(INPUTDIR)/body -type f -name '*.md' -not -path '*/00-draft.md'| sort)
endif

ENDMATTER = "$(INPUTDIR)/end-matter"/*.md

PATHS = $(FRONTMATTER) \
	$(BODY) \
	$(ENDMATTER) \
	$(INPUTDIR)/config.yaml

NO_FM_PATHS = \
	$(BODY) \
	$(ENDMATTER) \
	$(INPUTDIR)/config.yaml


BASE_PANDOC_PARAMS = \
	--from markdown+smart \
	-H "$(STYLEDIR)/preamble.tex" \
	--variable=section-in-header:$(SECTIONHEADER) \
	--template="$(STYLEDIR)/template.tex" \
	--bibliography="$(BIBFILE)" 2>pandoc.log \
	--csl=$(CSL) \
	--highlight-style pygments \
	--number-sections \
	--filter pandoc-crossref \
	$(BLIND_REVIEW) \
	$(DEFAULT_FM)

ifneq (,$(findstring $(toc),no-n-off))
	PANDOC_TOC =
else ifneq (,$(findstring $(toc),yes-y-on))
  PANDOC_TOC = "--toc"
else
  PANDOC_TOC = $(DEFAULT_TOC)
endif

pdf: clean
	pandoc \
	$(PATHS) \
	$(BASE_PANDOC_PARAMS) \
	$(PANDOC_TOC) \
	-o "$(OUTPUTDIR)/thesis.pdf" \
	--pdf-engine=$(ENGINE) \
	--verbose

tex: clean
	pandoc \
	$(PATHS) \
	$(BASE_PANDOC_PARAMS) \
	$(PANDOC_TOC) \
	-o "$(OUTPUTDIR)/thesis.tex" \
	--pdf-engine=$(ENGINE)

docx: clean
	pandoc \
	$(NO_FM_PATHS) \
	$(BASE_PANDOC_PARAMS) \
	$(PANDOC_TOC) \
	--reference-doc style/docx_templates/${TEMPLATE}.docx \
	-o "$(OUTPUTDIR)/thesis.docx"

docx-thesis: clean
	$(MAKE) template=thesis docx

docx-article: clean
	$(MAKE) template=article docx

epub: clean
	pandoc \
	$(NO_FM_PATHS) \
	--from markdown+smart \
	--bibliography="$(BIBFILE)" 2>pandoc.log \
	--csl=$(CSL) \
	--highlight-style pygments \
	--number-sections \
	--filter pandoc-crossref \
	$(BLIND_REVIEW) \
	$(PANDOC_TOC) \
	-o "$(OUTPUTDIR)/thesis.epub"


count-prepare: clean
	@mkdir "$(OUTPUTDIR)/wc"
	@- $(foreach FILE,$(BODY), sed -E -f "style/strip-html-comments.sed" $(FILE) > "$(OUTPUTDIR)/wc/$(notdir $(FILE))";)

wc: count-prepare
	@wc -w $(OUTPUTDIR)/wc/*
	@grep targetWordCount $(INPUTDIR)/config.yaml

wcc:
	@wc -w $(BODY)
	@grep targetWordCount $(INPUTDIR)/config.yaml

cc: count-prepare
	@wc -m $(OUTPUTDIR)/wc/*

ccc:
	@wc -m $(BODY)

spellcheck:
	@- $(foreach FILE,$(BODY), languagetool $(OPTS) $(LANGUAGE) $(FILE);)

clean:
	@rm -rf $(OUTPUTDIR)
	@mkdir $(OUTPUTDIR)

.PHONY: help pdf docx html tex wc spellcheck
