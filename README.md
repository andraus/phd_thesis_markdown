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

This project needs an extra dependency besides the default ones from TomPollard's original project, which is `pandoc-crossref`. TomPollard uses latex for cross-referencing figures, tables, etc. But I think that pandoc-crossref does a better job at that. Check the sample files in `src/body` for details.

In OSX, you can install `pandoc-crossref` via homebrew:
```
brew install pandoc-crossref
```

Next sections are purely from TomPollards's great original project.


# Template for writing a PhD thesis in Markdown 

This repository provides a framework for writing a PhD thesis in Markdown. I used the template for my PhD submission to University College London (UCL), but it should be straightforward to adapt suit other universities too.

## Why write my thesis in Markdown?

Markdown is a super-friendly plain text format that can be easily converted to a bunch of other formats like PDF, Word and Latex. You'll enjoy working in Markdown because:
- it is a clean, plain-text format...
- ...but you can use Latex when you need it (for example, in laying out mathematical formula).
- it doesn't suffer from the freezes and crashes that some of us experience when working with large, image-heavy Word documents.
- it automatically handles the table of contents, bibliography etc with Pandoc.
- comments, drafts of text, etc can be added to the document by wrapping them in &lt;!--  --&gt;
- it works well with Git, so keeping backups is straightforward. Just commit the changes and then push them to your repository.
- there is no lock-in. If you decide that Markdown isn't for you, then just output to Word, or whatever, and continue working in the new format.

## Are there any reasons not to use Markdown?

There are some minor annoyances:
- if you haven't worked with Markdown before then you'll find yourself referring to the style-guide fairly often at first.
- it isn't possible to add a short caption to figures and tables. This means that /listoftables and /listoffigures include the long-caption, which probably isn't what you want. If you want to include the list of tables and list of figures, then you have to write them manually.
- the style documents in this framework could be improved. The PDF and HTML (thanks [@ArcoMul](https://github.com/ArcoMul)) outputs are acceptable, but ~~HTML and~~ Word needs work if you plan to output to this format.
- there is no straightforward way of specifying image size in the markdown right now, though this functionality is coming (see: https://github.com/tompollard/phd_thesis_markdown/issues/15)
- ... if there are more, please add them here.

## How is the template organised?

- README.md => these instructions.
- License.md => terms of reuse (MIT license).
- Makefile => contains instructions for using Pandoc to produce the final thesis.
- output/ => directory to hold the final version.
- src/ => directory to hold the thesis content. Includes the references.bib file.
- src/figures/ => directory to hold the figures.
- style/ => directory to hold the style documents.

## How do I get started?

1. Install the following software:
    - A text editor, like [Sublime](https://www.sublimetext.com/), which is what you'll use write the thesis.  
    - A LaTex distribution (for example, [MacTex](https://tug.org/mactex/) for Mac users).
    - [Pandoc](http://johnmacfarlane.net/pandoc), for converting the Markdown to the output format of your choice.  You may also need to install [Pandoc cite-proc](http://pandoc.org/demo/example19/Extension-citations.html) to create the bibliography.
    - Git, for version control.
2. [Fork the repository](https://github.com/tompollard/phd_thesis_markdown/fork) on Github  
3. Clone the repository onto your local computer (or [download the Zip file](https://github.com/tompollard/phd_thesis_markdown/archive/master.zip)).  
4. Navigate to the directory that contains the Makefile and type "make pdf" (or "make html") at the command line to update the PDF (or HTML) in the output directory.  
**In case of an error** (e.g. `make: *** [pdf] Error 43`) run the following commands:  
    ```
    sudo tlmgr install truncate
    sudo tlmgr install tocloft
    sudo tlmgr install wallpaper
    sudo tlmgr install morefloats
    sudo tlmgr install sectsty
    sudo tlmgr install siunitx
    sudo tlmgr install threeparttable
    sudo tlmgr update l3packages
    sudo tlmgr update l3kernel
    sudo tlmgr update l3experimental
    ```
    
5. Edit the files in the 'src' directory, then goto step 4.  

## What else do I need to know?

Some useful points, in a random order:
- each chapter must finish with at least one blank line, otherwise the header of the following chapter may not be picked up.
- add two spaces at the end of a line to force a line break.
- the template uses [John Macfarlane's Pandoc](http://johnmacfarlane.net/pandoc/README.html) to generate the output documents. Refer to this page for Markdown formatting guidelines.
- PDFs are generated using the Latex templates in the style directory. Fonts etc can be changed in the tex templates.
- To change the citation style, just overwrite ref_format.csl with the new style. Style files can be obtained from [citationstyles.org/](http://citationstyles.org/)
- For fellow web developers, there is a Grunt task file (Gruntfile.js) which can be used to 'watch' the markdown files. By running `$ npm install` and then `$ npm run watch` the PDF and HTML export is done automatically when saving a Markdown file.
- You can automatically reload the HTML page on your browser using LiveReload with the command `$ npm run livereload`. The HTML page will automatically reload when saving a Markdown file after the export is done.

# Contributing

Contributions to the template are encouraged! There are lots of things that could improved, like:
- finding a way to add short captions for the figures and tables, so that the lists of figures and tables can be automatically generated.
- cleaning up the Latex templates, which are messy at the moment.
- improving the style of Word and Tex outputs.

Please fork and edit the project, then send a pull request.
