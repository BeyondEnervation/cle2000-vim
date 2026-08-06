if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

setlocal commentstring=*\ %s
setlocal comments=:*
setlocal formatoptions+=croql
setlocal formatoptions-=t
setlocal suffixesadd=.c2m,.x2m

let b:undo_ftplugin = 'setlocal commentstring< comments< formatoptions< suffixesadd<'
