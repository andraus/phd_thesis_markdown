# Model for thesis or dissertations of Unicamp

This project is a fork from https://github.com/tompollard/phd_thesis_markdown, which I'm very thankful for.

It was heavily modified to incorporate Unicamp's front-matter requirements, and my own preferences.

General info about this template can be found through the previously mentioned link. This README file will have specifics about my changes. 

## Main features:

- Already structured and ready-to-go Unicamp's thesis front-matter format and requirements.
- Automatic bibliography citation
- Convenient Makefile compile output
- Makefile supports different citation styles

## Specifics

In general terms, you will write your text in light markdown syntax, which will be compiled into pdf (or TeX, or docx) through pandoc. If you're unfamiliar with those terms, I recommend to read TomPollard's original README file, and the README file of pandoc.

`/src`folder is divided in three base sections: `body`, `front-matter` and `end-matter`.

- `body` will contain the base source text of your work. 
- `front-matter` will produce the initial pages of your work, including title page, face page, approval sheet, abstract, ToC, etc.
- similarly, `end-matter` will produce the appendixes and reference section

The whole idea, is to customize front-matter and end-matter sections once, and just work in the files of `body` section.

A few commands to get started:

- `make pdf` will generate a full pdf.
- `make pdf strip-frontmatter=yes` will generate a pdf without any front matter.
- `make pdf bibstyle=APA` will generate a pdf with bibliography references in APA style (default is ABNT).
- Use command `make help` to see all possible options.

## Dependencies

# `pandoc-crossref`
This project needs an extra dependency besides the default ones from TomPollard's original project, which is `pandoc-crossref`. TomPollard uses latex for cross-referencing figures, tables, etc. but I think that pandoc-crossref does a better job at that. Check the sample files in `src/body` for details.

In OSX, you can install `pandoc-crossref` via homebrew:
```
brew install pandoc-crossref
```

# `wc`

The target `make wc` will count words in directory `src\body`. The tool `wc` is preloaded in OSX Darwin, however it may be necessary to install it in other operational system.

# `language-tool`

The target `make spellcheck` will check the grammar in files in `src\body`. The tool `languagetool` will need to be installed. In OSX, you can install `languagetool` via homebrew:
```
brew install languagetool
```

Follow up on TomPollard's original [README](TP-README.md).

-- *Augusto Andraus*

