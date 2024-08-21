set nocompatible

" VimPlug {{{
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
let g:netrw_dynamic_maxfilenamelen = 32
let g:netrw_liststyle = 3

"Plug 'vim-scripts/Gundo'
Plug 'tmhedberg/SimpylFold'
Plug 'Konfekt/FastFold'
Plug 'kopischke/vim-stay'

Plug 'tpope/vim-fugitive'
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
Plug 'airblade/vim-gitgutter'
Plug 'jszakmeister/vim-togglecursor'
Plug 'NLKNguyen/papercolor-theme'

"Plug 'zxqfl/tabnine-vim'
""Plug 'Valloric/YouCompleteMe'
"Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'

"Plug 'chrisbra/csv.vim'
Plug 'groenewege/vim-less'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'posva/vim-vue'
Plug 'mxw/vim-jsx'
Plug 'honza/dockerfile.vim'
Plug 'zchee/vim-flatbuffers'
Plug 'hashivim/vim-terraform'
Plug 'towolf/vim-helm'
Plug 'vim-scripts/nginx.vim'

if executable('rg')
  " Use rg over grep
  set grepprg=rg\ vimgrep\ --smart-case\ --follow

  " hack to ignore translation files and external js libs in Odoo projects
  autocmd Filetype python,xml set grepprg=rg\ --vimgrep\ --glob=!i18n/*\ --glob=!static/lib/*\ --glob=!data/*\ --glob=!fonts/*\ --glob=!*.min.*\ --glob=!*.css.map

  nnoremap <silent> <C-p> :FZF<CR>
  let g:fzf_files_command = 'iarg --files --no-ignore --hidden --follow --glob "!{dir_to_ignore}/*"'

  " bind K to grep word under cursor
  nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

  " bind Rg to grep shortcut
  command! -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!
endif

Plug 'itchyny/lightline.vim'
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filepath', 'modified' ] ]
      \ },
      \ 'component': {
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
      \   'filepath': '%{expand("%:~:.")}'
      \ },
      \ }
call plug#end()
" }}}

" ALE {{{
let g:ale_completion_enabled = 1
let g:ale_linters = {
\   'javascript': ['prettier'],
\   'python': ['flake8'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier'],
\   'json': ['prettier'],
\   'markdown': ['prettier'],
\   'python': ['black'],
\}
let g:ale_fix_on_save = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_python_flake8_options = '--ignore=B011 --max-line-length=120'
let g:ale_yaml_yamllint_options = '-d "{extends: relaxed, rules: {line-length: disable}}"'
" }}}

" Global config {{{
set backupdir=~/.vim/tmp/backups//
set directory=~/.vim/tmp/swaps//
set viewdir=~/.vim/tmp/views//
set undofile
set undodir=~/.vim/tmp/undo//
set listchars=tab:»·,trail:·
set background=dark
set wildignore+=*.sw?,*.pyc
set hlsearch
set joinspaces
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set clipboard=unnamed
set mouse=a
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end
set number
if !$TERM_PROGRAM =~ "Apple_Terminal"
    set termguicolors
endif
colorscheme PaperColor
""" }}}
" Leader, Filetype and autocommand {{{
let mapleader=","
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

filetype plugin indent on

autocmd FocusLost * :wa
autocmd Filetype make setlocal noexpandtab list
autocmd Filetype bash,python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent "fileformat=unix
" commit: https://stackoverflow.com/questions/39553825/vim-double-indents-python-files/62348570#62348570
let g:pyindent_open_paren=shiftwidth()
autocmd Filetype python nnoremap <buffer> <leader>bp :normal oimport pdb; pdb.set_trace()  # TODO: BREAKPOINT  # noqa<Esc>
function! PythonRemoveAllBreakpoints()
    execute "g/^.*import pdb; pdb.set_trace\(\).*/d"
endfunction
autocmd Filetype python nnoremap <buffer> <leader>dbp :call PythonRemoveAllBreakpoints()<CR>

autocmd BufNewFile,BufRead *.css setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
" }}}
augroup highlightLineNumber
  autocmd!
  autocmd ColorScheme * highlight LineNr ctermfg=blue ctermbg=none
  autocmd ColorScheme * highlight CursorLineNr ctermfg=yellow ctermbg=none
augroup END
