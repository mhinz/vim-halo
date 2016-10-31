if !has('timers')
  echomsg "This Vim doesn't support timers."
  finish
endif

" s:setup_colors() {{{1
function! s:setup_colors() abort
  if !hlexists('Halo')
    highlight Halo guifg=white guibg=#F92672 ctermfg=white ctermbg=197
  endif
endfunction

" s:process_config() {{{1
function! s:process_config(config) abort
  let config = deepcopy(s:defaults)
  if has_key(a:config, 'hlgroup')
    let config.hlgroup = a:config.hlgroup
  endif
  if has_key(a:config, 'intervals') && !empty(a:config.intervals)
    " We require an odd length for the invervals list. Truncate otherwise.
    let config.intervals = len(a:config.intervals) % 2
          \ ? a:config.intervals
          \ : a:config.intervals[:-2]
  endif
  return config
endfunction

" s:new() {{{1
function! s:new(config) abort
  let obj = {}
  let obj.id = -1
  let obj.config = s:process_config(a:config)

  function! obj.hide(_)
    silent! call matchdelete(self.id)
    if empty(self.config.intervals)
      return
    endif
    let show_in_msecs = remove(self.config.intervals, 0)
    return timer_start(show_in_msecs, self.show)
  endfunction

  function! obj.show(_)
    let self.id = matchaddpos(self.config.hlgroup, [line('.')])
    let hide_in_msecs = remove(self.config.intervals, 0)
    return timer_start(hide_in_msecs, self.hide)
  endfunction

  return obj
endfunction

" halo#run() {{{1
function! halo#run(...) abort
  let halo = s:new(a:0 && type(a:1) == type({}) ? a:1 : {})
  return halo.show(0)
endfunction
" }}}

augroup halo
  autocmd!
  autocmd ColorScheme * call s:setup_colors()
augroup END

call s:setup_colors()

let s:defaults = {
      \ 'hlgroup':   'Halo',
      \ 'intervals': [100, 100, 100, 100, 100]
      \ }

" vim: fdm=marker
