syn match scalaScaladocBegin '/\*\*' nextgroup=scalaScaladocBrief skipwhite contained
syn region scalaScaladocBrief start="\(/\*\*\)\@<=" end="\.\(\s\+\|\s*\*/\|\n\)\@=" contained
syn region scalaMultilineComment start="/\*" end="\*/" contains=scalaTodo,@Spell keepend fold
syn region scalaScaladocComment start="/\*\*" end="\*/" contains=scalaScaladocComment,scalaScaladocBegin,scalaScaladocBrief,scalaDocLinks,scalaParameterAnnotation,scalaCommentAnnotation,scalaTodo,scalaCommentCodeBlock,@Spell keepend fold

augroup ScalaColors
    autocmd!
    autocmd ColorScheme * highlight link scalaScaladocBegin scalaScaladocComment
    autocmd ColorScheme * highlight scalaScaladocBrief   guifg=magenta guibg=none gui=bold ctermfg=magenta ctermbg=none cterm=bold
    autocmd ColorScheme * highlight scalaScaladocComment guifg=magenta guibg=none gui=none ctermfg=magenta ctermbg=none cterm=none
augroup END
