let s:halo_id = -1

highlight Halo guifg=white guibg=#F92672 ctermfg=white ctermbg=197

" halo#show() {{{1
function! halo#run(...) abort
  call s:show()
  call timer_start(100, function('s:show'), {'repeat': 2})
endfunction

" halo#start() {{{1
function! s:show() abort
  let s:halo_id = matchaddpos('Halo', [line('.')])
  call timer_start(50, function('s:hide'))
endfunction

" halo#show() {{{1
function! s:hide() abort
  silent! call matchdelete(s:halo_id)
endfunction

" vim: fdm=marker
