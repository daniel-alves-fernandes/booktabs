/******************************************************************************
booktabs.ado

version 2.1.3

author: Daniel Fernandes
contact: daniel.fernandes@eui.eu
******************************************************************************/

capture: program drop booktabs
program define booktabs
  syntax name(id="subcommand" name=subcommand) using/, *

  if inlist("`subcommand'","export","addline") booktabs_`subcommand' `0'
  else{
    noisily: display as error "{bf:booktabs `subcommand'} not recognized"
    exit 199
  }

end

capture: program drop booktabs_export
program define booktabs_export
  syntax name using/, [TABLEonly] [replace] [append] [FONTsize(string)]

  collect style cell border_block, border(left right, pattern(nil))

  if !inlist("`fontsize'","","normalsize","small","footnotesize","scriptsize","tiny"){
    noisily: display as error "fontsize not specified correctly"
    exit 198
  }

  collect export `using', `tableonly' `replace' `append'
  mata: booktabs_export("`using'","`tableonly'","`fontsize'")
end

capture: program drop booktabs_addline
program define booktabs_addline
  syntax name using/, [table(integer 1)] line(integer) str(string)

  mata: booktabs_addline("`using'",`table',`line',"`str'")
end

mata:

void booktabs_mattofile(mat,filename){
  unlink(filename)

  tfile = fopen(filename,"rw")
  for (i=1; i<=rows(mat); i++){
    fput(tfile,mat[i])
  }
  fclose(tfile)
}


void booktabs_export(filename,mode,fontsize){
  mat = cat(filename)
  mat = ("") \ mat \ ("")

  lines = selectindex(strmatch(mat,"\cline{*}"))
  for (i=1; i<=rows(lines); i++){
    opts = substr(mat[lines[i]],strpos(mat[lines[i]],"{"),.)
    mat[lines[i]] = "\cmidrule" + opts
  }
  mat[colmax(lines)] = "\bottomrule"
  mat[colmin(lines)] = "\toprule"

  if (fontsize != ""){
    ntables = sum(strmatch(mat,"\begin{tabular}*"))
    assert(ntables == sum(strmatch(mat,"\end{tabular}*")))

    for (i=1; i<=ntables; i++){
      calltab = selectindex(strmatch(mat,"\begin{tabular}*"))[i]
      endtab = selectindex(strmatch(mat,"\end{tabular}*"))[i]

      mat = mat[1..calltab-1] \ ("\begin{"+fontsize+"}") \
            mat[calltab..endtab] \ ("\end{"+fontsize+"}") \
            mat[endtab+1..rows(mat)]
    }
  }
  mat = mat[2..rows(mat)-1]

  if (mode == ""){
    mat = mat[1] \ ("\usepackage{booktabs}") \ mat[2..rows(mat)]
  }

  booktabs_mattofile(mat,filename)
}


function booktabs_addline(filename,tab,line,str){
  mat = cat(filename)
  calltab = selectindex(strmatch(mat,"\begin{tabular}*"))[tab]
  endtab = selectindex(strmatch(mat,"\end{tabular}*"))[tab]

  table = mat[calltab+1..endtab-1]
  where = selectindex(strmatch(table,"*\\"))[line]

  table = table[1..where] \ (str) \ table[where+1..rows(table)]
  mat = mat[1..calltab] \ table \ mat[endtab..rows(mat)]

  booktabs_mattofile(mat,filename)
}

end
