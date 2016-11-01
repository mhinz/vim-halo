if !has('timers')
  echomsg "This Vim doesn't support timers."
  finish
endif

augroup halo
  autocmd!
  autocmd ColorScheme *
        \ highlight default Halo guifg=white guibg=#F92672 ctermfg=white ctermbg=197
augroup END

highlight default Halo guifg=white guibg=#F92672 ctermfg=white ctermbg=197

let s:defaults = {
      \ 'hlgroup':   'Halo',
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

" s:show() {{{1
function! s:show(_) abort
  let s:halo_id = matchaddpos(s:runconfig.hlgroup, s:get_shape(s:runconfig.shape))
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
" }}}

" s:get_shape() {{{1
function! s:get_shape(shape) abort
  if a:shape == 'halo2'
    return s:get_shape_halo2()
  elseif a:shape == 'cross1'
    return s:get_shape_cross1()
  elseif a:shape == 'cross2'
    return s:get_shape_cross2()
  elseif a:shape == 'cross2halo1'
    return s:get_shape_cross2halo1()
  elseif a:shape == 'rectangle2'
    return s:get_shape_rectangle2()
  elseif a:shape == 'line'
    return s:get_shape_line()
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
          \ [ line+1, col+2    ],
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
