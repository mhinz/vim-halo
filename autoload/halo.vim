let s:halo_id = -1

" Configuration {{{1
highlight Halo guifg=white guibg=#F92672 ctermfg=white ctermbg=197

let s:config = {
      \ 'hlgroup':   'Halo',
      \ 'repeat':    3,
      \ 'intervals': [200]
      \ }

" halo#run() {{{1
function! halo#run(...) abort
  let s:runconfig = deepcopy(s:config)
  " We require an odd length for the invervals list. Truncate otherwise.
  if !(len(s:runconfig.intervals) % 2)
    call remove(s:runconfig.intervals, 0)
  endif
  for _ in range(s:runconfig.repeat)
    call s:show()
  endfor
endfunction

" s:show() {{{1
function! s:show() abort
  let s:halo_id = matchaddpos(s:runconfig.hlgroup, [line('.')])
  let hide_in_msecs = remove(s:runconfig.intervals, 0)
  return timer_start(hide_in_msecs, function('s:hide'))
endfunction

" s:hide() {{{1
function! s:hide() abort
  silent! call matchdelete(s:halo_id)
  if empty(s:runconfig.intervals)
    return
  endif
  let show_in_msecs = remove(s:runconfig.intervals, 0)
  return timer_start(show_in_msecs, function('s:show'))
endfunction

" vim: fdm=marker
