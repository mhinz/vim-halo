let s:halo_id = -1

" Configuration {{{1
highlight Halo guifg=white guibg=#F92672 ctermfg=white ctermbg=197

let s:config = {
      \ 'hlgroup':  'Halo',
      \ 'repeat':   1,
      \ 'interval': [500, 1000],
      \ }

" halo#show() {{{1
function! halo#run(...) abort
  call s:show()
  if s:config.repeat > 1
    call timer_start(
          \ s:config.interval[1],
          \ function('s:show'),
          \ { 'repeat': s:config.repeat - 1 })
  endif
endfunction

" halo#start() {{{1
function! s:show() abort
  let s:halo_id = matchaddpos('Halo', [line('.')])
  call timer_start(s:config.interval[0], function('s:hide'))
endfunction

" halo#show() {{{1
function! s:hide() abort
  silent! call matchdelete(s:halo_id)
endfunction

" vim: fdm=marker
