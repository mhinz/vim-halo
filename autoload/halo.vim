" Configuration {{{1
highlight Halo guifg=white guibg=#F92672 ctermfg=white ctermbg=197
autocmd ColorScheme *
      \ highlight Halo guifg=white guibg=#F92672 ctermfg=white ctermbg=197

let s:defaults = {
      \ 'hlgroup':   'Halo',
      \ 'intervals': [100, 100, 100, 100, 100]
      \ }

" s:process_config() {{{1
function! s:process_config(userconfig) abort
  if type(a:userconfig) isnot type({})
    redraw
    echomsg "Try halo#run({'hlgroup': 'Halo', 'intervals': [200, 200, 200] })"
    return
  endif
  if has_key(a:userconfig, 'hlgroup')
    let s:runconfig.hlgroup = a:userconfig.hlgroup
  endif
  if has_key(a:userconfig, 'intervals')
    " We require an odd length for the invervals list. Truncate otherwise.
    let s:runconfig.intervals = len(a:userconfig.intervals) % 2
          \ ? a:userconfig.intervals
          \ : a:userconfig.intervals[:-2]
  endif
endfunction

" s:show() {{{1
function! s:show(_) abort
  let s:halo_id = matchaddpos(s:runconfig.hlgroup, [line('.')])
  let hide_in_msecs = remove(s:runconfig.intervals, 0)
  return timer_start(hide_in_msecs, function('s:hide'))
endfunction

" s:hide() {{{1
function! s:hide(_) abort
  silent! call matchdelete(s:halo_id)
  if empty(s:runconfig.intervals)
    return
  endif
  let show_in_msecs = remove(s:runconfig.intervals, 0)
  return timer_start(show_in_msecs, function('s:show'))
endfunction

" halo#run() {{{1
function! halo#run(...) abort
  let s:runconfig = deepcopy(s:defaults)
  if a:0
    call s:process_config(a:1)
  endif
  call s:show(0)
endfunction

" vim: fdm=marker
