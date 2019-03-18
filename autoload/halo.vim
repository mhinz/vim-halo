if !has('timers')
  echomsg "This Vim doesn't support timers."
  finish
endif

augroup halo
  autocmd!
  autocmd ColorScheme * highlight default link Halo IncSearch
  autocmd WinLeave    * call halo#reset()
augroup END

highlight default link Halo IncSearch

let s:defaults = {
      \ 'hlgroup':   'Halo',
      \ 'ticks':     5,
      \ 'intervals': [100, 100, 100, 100, 100],
      \ 'shape':     'halo1',
      \ }

" s:process_config() {{{1
function! s:process_config(config) abort
  let config = deepcopy(s:defaults)
  if type(a:config) isnot type({})
    redraw
    echomsg "Try halo#run({'hlgroup': 'Halo', 'intervals': [200, 200, 200] })"
    return config
  endif
  if has_key(a:config, 'hlgroup')
    let config.hlgroup = a:config.hlgroup
  endif
  if has_key(a:config, 'intervals') && !empty(a:config.intervals)
    " We require an odd length for the invervals list. Truncate otherwise.
    let config.intervals = len(a:config.intervals) % 2
          \ ? a:config.intervals
          \ : a:config.intervals[:-2]
    let config.intervals = reverse(config.intervals)
    let config.ticks = len(config.intervals)
  endif
  if has_key(a:config, 'shape')
    let config.shape = a:config.shape
  endif
  return config
endfunction

" s:clear() {{{1
function! s:clear() dict abort
  if exists('w:halo_id')
    call matchdelete(w:halo_id)
    unlet w:halo_id
    return 1
  endif
endfunction

" s:reset() {{{1
function! s:reset() dict abort
  let self.ticks = -1
  call self.clear()
endfunction

" s:tick() {{{1
function! s:tick(_) dict abort
  let self.ticks -= 1
  let active = self.ticks >= 0
  if !self.clear() && active
    let w:halo_id = matchaddpos(self.hlgroup, s:get_shape(self.shape))
  endif
  if active
    call timer_start(self.intervals[self.ticks], self.tick)
  else
    call self.reset()
  endif
endfunction

" halo#run() {{{1
function! halo#run(...) abort
  call halo#reset()
  let s:halo       = s:process_config(a:0 ? a:1 : {})
  let s:halo.pos   = getcurpos()
  let s:halo.clear = function('s:clear')
  let s:halo.reset = function('s:reset')
  let s:halo.tick  = function('s:tick')
  call s:halo.tick(0)
  return ''
endfunction

" halo#reset() {{{1
function! halo#reset() abort
  if exists('s:halo')
    call s:halo.reset()
  endif
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
