{smcl}
{* *! version 1.0  6mar2021}{...}

{title:Booktabs}

{pstd}
{hi:booktabs} {hline 2} exports tables created by the {help collect} and the {help etable} commands in .tex format using booktabs. {it:Requires Stata 17.}

{marker syntax}{...}
{title:Syntax}

{pstd}
  {cmd:booktabs} {help using} {it:filename}, {bf:[replace]} {bf:[tableonly]} {bf:[append]}


{title:Options}

{pstd}
{bf:replace}: overwrite existing file

{pstd}
{bf:tableonly}: export only the table to the specified file

{pstd}
{bf:append}: append to an existing file

{title:Author}

{pstd}
{it:Daniel Alves Fernandes}{break}
European University Institute

{pstd}
daniel.fernandes@eui.eu
