{smcl}
{* *! version 2.0  21mar2021}{...}

{title:Booktabs}

{pstd}
{hi:booktabs} {hline 2} exports tables created by the {help collect} and the {help etable} commands in .tex format using booktabs. {it:Requires Stata 17.}

{marker syntax}{...}
{title:Syntax}

{pstd}
Export tables:

{pstd}
  {cmd:booktabs export} {help using} {it:filename.tex}, {bf:[replace]} {bf:[tableonly]} {bf:[append]} {bf:[fontsize(}{it:size}{bf:)]}

{pstd}
Add custom lines to an exported table:

{pstd}
{cmd:booktabs addline} {help using} {it:filename.tex}, {bf:[table(}{it:int}{bf:)]} {bf:line(}{it:int}{bf:)} {bf:str(}{it:string}{bf:)}


{title:Options for booktabs export}

{pstd}
{bf:replace}: overwrite existing file

{pstd}
{bf:tableonly}: export only the table to the specified file

{pstd}
{bf:append}: append to an existing file

{pstd}
{bf:fontsize(}{it:size}{bf:)}: specify size of letter font to be used within tabulars. Available options: {it:normalsize}, {it:small}, {it:footnotesize}, {it:scriptsize}, {it:tiny}.


{title:Options for booktabs addline}

{pstd}
{bf:table(}{it:int}{bf:)}: select the table where the string should be added. This option does not need to be specified if there is only one table in the selected {it:tex} file.

{pstd}
{bf:line(}{it:int}{bf:)}: select the line where the string should be added.

{pstd}
{bf:str(}{it:string}{bf:)}: string to be added to the table.


{title:Author}

{pstd}
{it:Daniel Alves Fernandes}{break}
European University Institute

{pstd}
daniel.fernandes@eui.eu
