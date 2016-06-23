let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_neobundle_exporter')
  let &cpo = s:save_cpo
  unlet s:save_cpo

  finish
endif

command! -complete=file -nargs=1 ExportNeobundle :call neobundle_exporter#export(<f-args>)

let g:loaded_neobundle_exporter = 1
let &cpo = s:save_cpo
unlet s:save_cpo
