" Automatically toggle `hlsearch`
" credit goes to @purpleP for this genius solution
" ================================================
if exists('g:loaded_autohighlight')
  finish
endif
let g:loaded_autohighlight = 1

let s:disable = 0

augroup delight
  autocmd!
  autocmd OptionSet hlsearch call <SID>Delight(v:option_old, v:option_new)
augroup END

function! s:HighlightOn()
  if s:disable
    let s:disable = 0
    return
  endif
  silent! if !search('\%#\zs'.@/,'cnW')
  call <SID>HighlightOff()
endif
endfunction

function! s:HighlightOff()
  if v:hlsearch && mode() is 'n'
    sil call feedkeys("\<Plug>(HighlightOff)", 'm')
  endif
endfunction

function! s:ToggleHighlight()
  if matchstr(@", @/) == @"
    let s:disable = 1
  elseif search('\%#\zs'.@/,'cnW')
    call <SID>HighlightOff()
  endif
endfunction

function! s:Delight(old, new)
  if a:old == 0 && a:new == 1
    noremap <expr> <Plug>(HighlightOff) execute('nohlsearch')[-1]
    noremap! <expr> <Plug>(HighlightOff) execute('nohlsearch')[-1]
    autocmd delight CursorMoved * call <SID>HighlightOn()
    autocmd delight TextYankPost * call <SID>ToggleHighlight()
  elseif a:old == 1 && a:new == 0
    nunmap <Plug>(HighlightOff)
    unmap! <expr> <Plug>(HighlightOff)
    autocmd! delight CursorMoved
    autocmd! delight TextYankPost
  else
    return
  endif
endfunction

if v:hlsearch
  call <SID>Delight(0, 1)
endif

