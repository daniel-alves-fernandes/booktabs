/******************************************************************************
booktabs.ado

version 2.0

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
  syntax name using/, [tableonly] [replace] [append]

  collect style cell border_block, border(left right, pattern(nil))

  collect export `using', `tableonly' `replace' `append'
  mata: booktabs_export("`using'","`tableonly'")
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

function booktabs_getpos(mat,str){
  numeric matrix lines

  lines = 0
  for (i=1; i<=rows(mat); i++){
    if (strmatch(mat[i],str)) lines = lines , i
  }
  lines = lines[1,2..cols(lines)]
  return(lines)
}

void booktabs_export(filename,mode){
  mat = cat(filename)

  lines = booktabs_getpos(mat,"\cline{*}")
  for (i=1; i<=cols(lines); i++){
    opts = substr(mat[lines[1]],strpos(mat[lines[1]],"{"),.)
    mat[lines[i]] = "\cmidrule" + opts
  }
  mat[rowmax(lines)] = "\bottomrule"
  mat[rowmin(lines)] = "\toprule"

  if (mode == ""){
    mat = mat[1] \ ("\usepackage{booktabs}") \ mat[2..rows(mat)]
  }

  booktabs_mattofile(mat,filename)
}


function booktabs_addline(filename,tab,line,str){
  string matrix mat
  string matrix table
  real scalar calltab
  real scalar endtab
  real scalar where

  mat = cat(filename)
  calltab = booktabs_getpos(mat,"\begin{tabular}*")[tab]
  endtab = booktabs_getpos(mat,"\end{tabular}*")[tab]

  table = mat[calltab..endtab]
  where = booktabs_getpos(table,"*\\")[line]

  table = table[1..where] \ (str) \ table[where+1..rows(table)]
  mat = mat[1..calltab-1] \ table \ mat[endtab..rows(mat)]

  booktabs_mattofile(mat,filename)
}

end
