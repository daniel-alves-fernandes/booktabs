/******************************************************************************
booktabs.ado

version 1.2

author: Daniel Fernandes
contact: daniel.fernandes@eui.eu
******************************************************************************/

capture: program drop booktabs
program define booktabs
  syntax using/, [tableonly] [replace] [append]

  collect style cell border_block, border(left right, pattern(nil))

  collect export `using', `tableonly' `replace' `append'
  mata: booktabs("`using'","`tableonly'")
end

mata:

void mattofile(mat,filename){
  unlink(filename)

  tfile = fopen(filename,"rw")
  for (i=1; i<=rows(mat); i++){
    fput(tfile,mat[i])
  }
  fclose(tfile)
}

function getpos(mat,str){
  numeric matrix lines

  lines = 0
  for (i=1; i<=rows(mat); i++){
    if (strmatch(mat[i],str)) lines = lines , i
  }
  lines = lines[1,2..cols(lines)]
  return(lines)
}

void booktabs(filename,mode){
  mat = cat(filename)

  lines = getpos(mat,"\cline{*}")
  for (i=1; i<=cols(lines); i++){
    opts = substr(mat[lines[1]],strpos(mat[lines[1]],"{"),.)
    mat[lines[i]] = "\cmidrule" + opts
  }
  mat[rowmax(lines)] = "\bottomrule"
  mat[rowmin(lines)] = "\toprule"

  if (mode == ""){
    mat =
    mat[1] \ ("\usepackage{booktabs}") \ mat[2..rows(mat)]
  }

  mattofile(mat,filename)
}

function addline(filename,tab,line,str){

  string matrix mat
  real scalar calltab
  real scalar endtab
  string matrix table
  real scalar where

  mat = cat(filename)
  calltab = getpos(mat,"\begin{tabular}*")[tab]
  endtab = getpos(mat,"\end{tabular}*")[tab]

  table = mat[calltab..endtab]
  where = getpos(table,"*\\")[line]

  table = table[1..where] \ (str) \ table[where+1..rows(table)]
  mat = mat[1..calltab-1] \ table \ mat[endtab..rows(mat)]

  mattofile(mat,filename)
}
end
