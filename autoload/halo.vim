if !has('timers')
  echomsg "This Vim doesn't support timers."
  finish
endif

augroup halo
  autocmd!
  autocmd ColorScheme *
        \ highlight default Halo guifg=white guibg=#F92672 ctermfg=white ctermbg=197
  autocmd CursorMoved,CursorMovedI * call s:stop()
augroup END

highlight default Halo guifg=white guibg=#F92672 ctermfg=white ctermbg=197

let s:defaults = {
      \ 'hlgroup':   'Halo',
      \ 'step':      0,
      \ 'intervals': [100, 100, 100, 100, 100],
      \ 'shape':     'halo1',
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
  if has_key(a:userconfig, 'intervals') && !empty(a:userconfig.intervals)
    " We require an odd length for the invervals list. Truncate otherwise.
    let s:runconfig.intervals = len(a:userconfig.intervals) % 2
          \ ? a:userconfig.intervals
          \ : a:userconfig.intervals[:-2]
  endif
  if has_key(a:userconfig, 'shape')
    let s:runconfig.shape = a:userconfig.shape
  endif
endfunction

" s:stop() {{{1
function! s:stop() abort
  if exists('s:runconfig') && has_key(s:runconfig, 'timer')
    call timer_stop(s:runconfig.timer)
    unlet! s:runconfig
  endif
  silent! call matchdelete(s:halo_id)
endfunction

" s:tick() {{{1
function! s:tick(_) abort
  if s:runconfig.step >= len(s:runconfig.intervals)
    return s:stop()
  endif
  let delay = s:runconfig.intervals[s:runconfig.step]
  if s:runconfig.step % 2 == 0
    let s:halo_id = matchaddpos(s:runconfig.hlgroup, s:get_shape(s:runconfig.shape))
  else
    silent! call matchdelete(s:halo_id)
  endif
  let s:runconfig.step += 1
  let s:runconfig.timer = timer_start(delay, function('s:tick'))
endfunction

" halo#run() {{{1
function! halo#run(...) abort
  call s:stop()
  let s:runconfig = deepcopy(s:defaults)
  if a:0
    call s:process_config(a:1)
  endif
  call s:tick(0)
  return ''
endfunction
" }}}

" s:get_shape() {{{1
function! s:get_shape(shape) abort
  if exists('*s:get_shape_'.a:shape)
    return s:get_shape_{a:shape}()
  endif
  return s:get_shape_halo1()
endfunction

" s:get_shape_line {{{1
function! s:get_shape_line()
  let curcol = col('.')
  lockmarks keepjumps normal! g0
  let begin = col('.')
  lockmarks keepjumps normal! g$
  let end = col('.')
  call cursor('.', curcol)

  return [[line('.'), begin, (end - begin) + 1]]
endfunction

" s:get_shape_halo1 {{{1
function! s:get_shape_halo1()
  let line = line('.')
  let col = col('.')
  if col == 1
    return [
          \ [ line-1, col  , 2 ],
          \ [ line  , col+1    ],
          \ [ line+1, col+1    ],
          \ [ line+1, col  , 2 ],
          \ ]
  else
    return [
          \ [ line-1, col-1, 3 ],
          \ [ line  , col-1    ],
          \ [ line  , col+1    ],
          \ [ line+1, col-1, 3 ],
          \ ]
  endif
endfunction

" s:get_shape_halo2 {{{1
function! s:get_shape_halo2()
  let line = line('.')
  let col = col('.')
  if col == 1
    return [
          \ [ line-2, col  , 3 ],
          \ [ line-1, col+2    ],
          \ [ line  , col+2    ],
          \ [ line+1, col+2    ],
          \ [ line+2, col  , 3 ],
          \ ]
  elseif col == 2
    return [
          \ [ line-2, col-1, 4 ],
          \ [ line-1, col+2    ],
          \ [ line  , col+2    ],
          \ [ line+1, col+2    ],
          \ [ line+2, col-1, 4 ],
          \ ]
  else
    return [
          \ [ line-2, col-2, 5 ],
          \ [ line-1, col-2    ],
          \ [ line-1, col+2    ],
          \ [ line  , col-2    ],
          \ [ line  , col+2    ],
          \ [ line+1, col-2    ],
          \ [ line+1, col+2    ],
          \ [ line+2, col-2, 5 ],
          \ ]
  endif
endfunction

" s:get_shape_cross1 {{{1
function! s:get_shape_cross1()
  let line = line('.')
  let col = col('.')
  if col == 1
    return [
          \ [ line-1, col   ],
          \ [ line  , col+1 ],
          \ [ line+1, col   ],
          \ ]
  else
    return [
          \ [ line-1, col   ],
          \ [ line  , col-1 ],
          \ [ line  , col+1 ],
          \ [ line+1, col   ],
          \ ]
  endif
endfunction

" s:get_shape_cross2 {{{1
function! s:get_shape_cross2()
  let line = line('.')
  let col = col('.')
  if col == 1
    return [
          \ [ line-2, col      ],
          \ [ line-1, col      ],
          \ [ line  , col+1, 2 ],
          \ [ line+1, col      ],
          \ [ line+2, col      ],
          \ ]
  elseif col == 2
    return [
          \ [ line-2, col      ],
          \ [ line-1, col      ],
          \ [ line  , col-1    ],
          \ [ line  , col+1, 2 ],
          \ [ line+1, col      ],
          \ [ line+2, col      ],
          \ ]
  else
    return [
          \ [ line-2, col      ],
          \ [ line-1, col      ],
          \ [ line  , col-2, 2 ],
          \ [ line  , col+1, 2 ],
          \ [ line+1, col      ],
          \ [ line+2, col      ],
          \ ]
  endif
endfunction

" s:get_shape_cross2halo1 {{{1
function! s:get_shape_cross2halo1()
  let line = line('.')
  let col = col('.')
  if col == 1
    return [
          \ [ line-2, col      ],
          \ [ line-1, col  , 2 ],
          \ [ line  , col+1, 2 ],
          \ [ line+1, col  , 2 ],
          \ [ line+2, col      ],
          \ ]
  elseif col == 2
    return [
          \ [ line-2, col      ],
          \ [ line-1, col-1, 3 ],
          \ [ line  , col-1    ],
          \ [ line  , col+1, 2 ],
          \ [ line+1, col-1, 3 ],
          \ [ line+2, col      ],
          \ ]
  else
    return [
          \ [ line-2, col      ],
          \ [ line-1, col-1, 3 ],
          \ [ line  , col-2, 2 ],
          \ [ line  , col+1, 2 ],
          \ [ line+1, col-1, 3 ],
          \ [ line+2, col      ],
          \ ]
  endif
endfunction

" s:get_shape_rectangle2 {{{1
function! s:get_shape_rectangle2()
  let line = line('.')
  let col = col('.')
  if col == 1
    return [
          \ [ line-2, col  , 3 ],
          \ [ line-1, col  , 3 ],
          \ [ line  , col+1, 2 ],
          \ [ line+1, col  , 3 ],
          \ [ line+2, col  , 3 ],
          \ ]
  elseif col == 2
    return [
          \ [ line-2, col-1, 4 ],
          \ [ line-1, col-1, 4 ],
          \ [ line  , col-1    ],
          \ [ line  , col+1, 2 ],
          \ [ line+1, col-1, 4 ],
          \ [ line+2, col-1, 4 ],
          \ ]
  else
    return [
          \ [ line-2, col-2, 5 ],
          \ [ line-1, col-2, 5 ],
          \ [ line  , col-2, 2 ],
          \ [ line  , col+1, 2 ],
          \ [ line+1, col-2, 5 ],
          \ [ line+2, col-2, 5 ],
          \ ]
  endif
endfunction
" }}}

" vim: fdm=marker
