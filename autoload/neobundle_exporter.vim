let s:save_cpo = &cpo
set cpo&vim

" Public functions {{{

function! neobundle_exporter#export(fname)
  let bundles = sort(neobundle#config#get_neobundles(), "s:compare_bundle")
  call s:export_toml(a:fname, bundles)
  echo "export done."
endfunction

" }}}

" Private functions {{{

function! s:compare_bundle(lhs, rhs)
  let l = tolower(a:lhs.name)
  let r = tolower(a:rhs.name)
  return (l ==# r ? 0 : l ># r ? 1 : -1)
endfunction

function! s:export_toml(fname, bundles)
  let lines = []
  for bundle in a:bundles
    let lines += s:bundle_to_toml_lines(bundle)
    let lines += [""]
  endfor
  call writefile(lines, a:fname)
endfunction

function! s:bundle_to_toml_lines(bundle)
  let lines = ["[[plugins]]"]

  call s:fold_bundle_config4(lines, a:bundle, "orig_name", "repo")

  if has_key(a:bundle, "lazy") && get(a:bundle, "lazy")
    call add(a:lines, s:toml_line(a:toml_key, get(a:bundle, "lazy")))
  endif
  call s:fold_bundle_config3(lines, a:bundle, "rtp")
  call s:fold_bundle_config3(lines, a:bundle, "rev")
  call s:fold_bundle_config3(lines, a:bundle, "build")

  if has_key(a:bundle, "autoload")
    call s:fold_bundle_config4(lines, a:bundle.autoload, "filetypes", "on_ft")
  endif

  return lines
endfunction

function! s:fold_bundle_config4(lines, bundle, key, toml_key)
  if has_key(a:bundle, a:key)
    call add(a:lines, s:toml_line(a:toml_key, get(a:bundle, a:key)))
  endif
endfunction

function! s:fold_bundle_config3(lines, bundle, key)
  return s:fold_bundle_config4(a:lines, a:bundle, a:key, a:key)
endfunction

function! s:toml_line(key, value)
  return (a:key . " = " . string(a:value))
endfunction

" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
