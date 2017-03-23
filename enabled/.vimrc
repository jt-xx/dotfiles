set nocompatible

" VimPlug {{{
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
"let g:netrw_banner = 0
let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
let g:netrw_altv = 1
"let g:netrw_winsize = 25
Plug 'tmhedberg/SimpylFold'
Plug 'Konfekt/FastFold'
Plug 'kopischke/vim-stay'
Plug 'ntpeters/vim-better-whitespace'

Plug 'tpope/vim-fugitive'
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
Plug 'airblade/vim-gitgutter'

Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'scrooloose/syntastic', { 'on': 'SyntasticCheck' }
let g:syntastic_python_flake8_args='--ignore=E501'

Plug 'dag/vim-fish'
Plug 'chrisbra/csv.vim'
Plug 'groenewege/vim-less'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'honza/dockerfile.vim'
Plug 'ctrlpvim/ctrlp.vim'
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " hack to ignore translation files and external js libs in Odoo projects
  autocmd Filetype python,xml set grepprg=ag\ --nogroup\ --nocolor\ --ignore-dir='i18n*'\ --ignore-dir='static/lib'\ --ignore-dir='fonts'\ --ignore-dir='*.min.*'\ --ignore-dir='*.css.map'\ --ignore-dir='data'

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " bind K to grep word under cursor
  nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

  " bind \ (backward slash) to grep shortcut
  command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
endif

Plug 'itchyny/lightline.vim'
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ }
call plug#end()
" }}}
" Global config not plugin dependent {{{
set backupdir=~/.vim/tmp/backups//
set directory=~/.vim/tmp/swaps//
set viewdir=~/.vim/tmp/views//
set undofile
set undodir=~/.vim/tmp/undo//
set listchars=tab:»·,trail:·
set background=dark
set number
set wildignore+=*.sw?,*.pyc
set hlsearch
set joinspaces

set mouse=a

hi LineNr ctermfg=darkgrey
""" }}}
" Leader, Filetype and autocommand {{{
let mapleader=","
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

filetype plugin indent on

autocmd FocusLost * :wa
autocmd Filetype make setlocal noexpandtab list
autocmd Filetype bash,python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix
autocmd Filetype python nnoremap <buffer> <leader>bp :normal oimport pdb; pdb.set_trace()  # TODO: BREAKPOINT  # noqa<Esc>
function! PythonRemoveAllBreakpoints()
    execute "g/^.*import pdb; pdb.set_trace\(\).*/d"
endfunction
autocmd Filetype python nnoremap <buffer> <leader>dbp :call PythonRemoveAllBreakpoints()<CR>

autocmd BufNewFile,BufRead *.css setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
" }}}
" python virtualenv support {{{
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF
" }}}
