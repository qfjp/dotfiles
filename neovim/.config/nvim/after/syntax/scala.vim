syn match scalaScaladocBegin "/\*\*" nextgroup=scalaScaladocBrief skipwhite contained
syn match scalaScaladocBrief /[ `_A-Za-z0-9$]\+\./ contained
syn region scalaMultilineComment start="/\*" end="\*/" contains=scalaTodo,@Spell keepend fold
syn region scalaScaladocComment start="/\*\*" end="\*/" contains=scalaScaladocComment,scalaScaladocBegin,scalaScaladocBrief,scalaDocLinks,scalaParameterAnnotation,scalaCommentAnnotation,scalaTodo,scalaCommentCodeBlock,@Spell keepend fold

highlight link scalaScaladocBegin scalaScaladocComment
highlight scalaScaladocBrief   guifg=magenta guibg=none gui=italic ctermfg=magenta ctermbg=none cterm=bold
highlight scalaScaladocComment guifg=magenta guibg=none gui=none   ctermfg=magenta ctermbg=none cterm=none
