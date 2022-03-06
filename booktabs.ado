/******************************************************************************
booktabs.ado

version 1.0

author: Daniel Fernandes
contact: daniel.fernandes@eui.eu
******************************************************************************/

capture: program drop booktabs
program define booktabs
  syntax using/, [tableonly] [replace] [append]

  collect export `using', `tableonly' `replace' `append'
  mata: booktabs("`using'","`tableonly'")
end

mata:
void booktabs(filename,mode){
  texfile = cat(filename)

  lines = 0
  for (i=1; i<=rows(texfile); i++){
    if (strmatch(texfile[i],"\cline{*}")) lines = lines , i
  }
  lines = lines[1,2..cols(lines)]
  for (i=1; i<=cols(lines); i++){
    texfile[lines[i]] = "\midrule"
  }
  texfile[rowmax(lines)] = "\bottomrule"
  texfile[rowmin(lines)] = "\toprule"

  if (mode == ""){
    texfile =
    texfile[1] \ ("\usepackage{booktabs}") \ texfile[2..rows(texfile)]
  }

  btfile = fopen(filename,"rw")
  for (i=1; i<=rows(texfile); i++){
    fput(btfile,texfile[i])
  }
  fclose(btfile)
}
end
