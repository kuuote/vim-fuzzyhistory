function! s:filter() abort
  let text = getcmdline()
  let newhist = copy(s:hist)
  let re = "\\v" .. join(split(text, "\\zs"), ".*")
  let case = text =~ '[[:upper:]]' ? '#' : '?' " similar smartcase
  call filter(newhist, 'v:val =~' .. case .. ' re')
  call deletebufline("%", 1, "$")
  call setline(1, newhist)
  call cursor("$", 1)
  redraw
endfunction

function! s:cmdline() abort
  autocmd FuzzyHistory CmdlineChanged * call s:filter()
  call input("candy:")
endfunction

function! s:leave() abort
  autocmd! FuzzyHistory CmdlineChanged
endfunction

augroup FuzzyHistory
  autocmd!
  autocmd CmdwinEnter * let s:hist = getline(1, "$")
  autocmd CmdlineLeave * call s:leave()
augroup END

nnoremap <silent> <expr> <Plug>(fuzzy-history) (empty(getcmdwintype()) ? "q:" : "") .. ":<C-u>call <SID>cmdline()<CR>"
