<!-- Lists -->
<!--
Item opcional. A lista deve ser elaborada de acordo com a ordem apresentada no texto, com cada item designado por seu título específico, acompanhado do respectivo número de página, salvo para os casos de listas de abreviaturas, siglas e símbolos.
-->
\newpage
\thispagestyle{empty}
\noindent
{\huge{Lista de Abreviaturas}}


BA

:   Boolean Algebra

CPL

:   Classical Propositional Logic

LFM

:   Wittgenstein's Lectures on the Foundations of Mathematics


<!--
The latex-heavy block below is a hack to prevent page numbering to commands
\listoffigures and \listoftables
-->
\cleardoublepage
\begingroup
\makeatletter
\let\ps@plain\ps@empty
\makeatother

\pagestyle{empty}
\listoffigures
\listoftables
\cleardoublepage
\endgroup
<!--
\noindent
Table 5.1  This is an example table . . .               \hfill{pp}  
Table x.x  Short title of the figure . . .              \hfill{pp}  
-->


