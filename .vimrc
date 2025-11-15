if !exists('g:vscode') 
  set runtimepath+=~/.dotfiles/vim
  runtime! init/*.vim
else
  set clipboard+=unnamed
  set ignorecase
  nnoremap <silent> <C-n> :<C-u>tabn<CR>
  nnoremap <silent> <C-p> :<C-u>tabp<CR>
  inoremap <silent> jj <ESC>
  inoremap <silent> kk <ESC>
  "move ^ and $
  noremap <S-h> ^
  noremap <S-l> $
  xmap gc  <Plug>VSCodeCommentary
  nmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine
  xnoremap < <gv
  xnoremap > >gv
  vnoremap v $h
  highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
endif
