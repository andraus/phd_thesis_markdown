#! /bin/sed -f
# Delete HTML comments
# i.e. everything between <!-- and -->
# by Stewart Ravenhall <stewart.ravenhall@ukonline.co.uk>

/<!--/ !b
:a
/-->/ !{
    N
    b a
}
s/<!--.*-->//

### colorized by sedsed, a SED script debugger/indenter/tokenizer/HTMLizer
### original script: http://sed.sf.net/grabbag/scripts/strip_html_comments.sed
