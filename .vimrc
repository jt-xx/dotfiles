set nocompatible                         " We're running Vim, not Vi!

" Switch syntax highlighting on, when the terminal has colors {{{
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    " :VimrcHelp " <F8> activates or desactivates hight lighting on results from searchs
    set hlsearch
    noremap <F8> :set hlsearch!<CR>:set hlsearch?<CR>
endif
" }}} ------------------------------------------------------------------------
" Only do this part when compiled with support for autocommands. {{{
if has("autocmd")
  if version >=600
    filetype plugin indent on
  endif

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    autocmd!
    autocmd BufRead *.txt setlocal tw=78
    autocmd FileType text setlocal textwidth=78
  augroup END

  augroup RubyFT
    autocmd!
    autocmd FileType ruby,eruby,yaml set ai sw=2 ts=2 et
  augroup END

  augroup Misc " TODO cleanup, use FileType where possible,...
    " au BufRead,BufWrite,BufNewFile,FileReadPost *.xml,*.xsl set et
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
    au BufRead,BufNewFile *.txt set et " tw=78
    au BufRead,BufNewFile *.xml,*.xsl set foldmethod=syntax foldcolumn=3 foldnestmax=2 foldlevel=2
    au BufRead,BufNewFile *.php,*.php3 set foldmethod=syntax foldcolumn=3 foldnestmax=2 foldlevel=2
    " au BufRead,BufNewFile *.py set foldmethod=indent foldcolumn=0 foldnestmax=2 foldlevel=2
    au BufRead,BufNewFile *.py set foldmethod=expr foldexpr=GetPythonFold(v:lnum) foldcolumn=3 foldnestmax=2 foldlevel=2
    au BufRead,BufNewFile *.py syn keyword pythonPreCondit  with as
    au BufRead,BufNewFile *.c,*.cpp,*.cs,*.java syn region foldBraces start="{" end="}" transparent fold
    au BufRead,BufNewFile *.css syn region foldCSS start="{" end="}" transparent fold keepend extend
    au BufRead,BufNewFile *.java syn region foldJavadoc start=,/\*\*, end=,\*/, transparent fold keepend extend
    au BufRead,BufNewFile *.c,*.cpp,*.cs,*.css,*.java syn sync fromstart
    au BufRead,BufNewFile *.c,*.cpp,*.cs,*.css,*.java set foldmethod=syntax foldcolumn=3 foldnestmax=2 foldlevel=2
    au BufReadPost *.py syn match antonyEq "[=]"
    au BufReadPost *.py hi antonyEq ctermfg=green
    " au BufReadPost *.py syn match antonyPar "[)(]"
    " au BufReadPost *.py hi antonyPar ctermfg=red
  augroup END

endif " has("autocmd")
" }}} ------------------------------------------------------------------------
set expandtab tabstop=4 shiftwidth=4     " expand tabs
set nolist listchars=tab:»·,trail:·      " disable display of tabs and trailing white spaces: 	
set backspace=indent,eol,start           " allow backspacing over everything in insert mode
set whichwrap+=<,>,[,]                   " allow arrow keys to move cursor in visual and insert mode
set textwidth=132                        " default text width
set autoindent                           " always autoindent
set nobackup                             " do not keep a backup file, use versions instead
set noerrorbells vb t_vb=                " no beep, no visual bell
set laststatus=2                         " always show status line
set showmode                             " show current mode
set ruler                                " show cursor position
set ignorecase smartcase                 " smartcase search
set hlsearch                             " highlight search
set joinspaces                           " insert two spaces after period wen joining lines
set report=0                             " show any changes
set viminfo='200,\"5000 history=500      " what info to store from an editing session

" screen dependent
if $TERM == "screen"                     " ! $TERM could be overwritten in .screenrc !
    set term="rxvt-xpm"
endif

" (terminal) speed dependent
set showcmd                              " show number of selected chars, lines, ...
set noshowmatch                          " do not show matching bracket

" file completion config (prefereably in autocmd for filetype)
set wig+=*.swp,*.swo                     " for vim
set wig+=*.o,*.obj,*~,*.exe              " for C

" advanced
set cpo-=<                               " enable recognition of special key codes in <>
set wildcharm=<TAB>                      " enable wildchar in command line and macro
set wildmenu                             " enhanced command line completion

" Load matchit (% to bounce from do to end, etc.)
runtime! macros/matchit.vim

" GUI {{{
set mouse=a
"(windows only) au GUIEnter * simalt ~x " start vim with maximized window
"set guifont="Fixed:pixelsize=20:width=semicondensed"
set guifont=Bitstream_Vera_Sans_Mono_Bold:h10:cANSI
behave xterm
colors koehler
" }}} ------------------------------------------------------------------------
" Colors {{{
"set background=dark                      " enable vivid colors for dark background terminal
set background=light                     " enable dark colors for bright background terminal
hi SpecialKey ctermfg=blue ctermbg=black guifg=darkgray guibg=black
hi Folded ctermfg=cyan ctermbg=blue
" }}} ------------------------------------------------------------------------
" Vtreeexplorer {{{
let treeExplVertical = 1
let treeExplWinSize = 25
let treeExplDirSort = 1
" }}} ------------------------------------------------------------------------
" TAB completion {{{
function! InsertTabWrapper(direction)
    let col = col('.') - 1
"   if !col || getline('.')[col - 1] !~ '\k'
" multibyte patch
    if !col || strpart(getline('.'), col-1, col) =~ '\s'
        return "\<tab>"
    elseif "backward" == a:direction
        return "\<c-p>"
    elseif "forward" == a:direction
        return "\<c-n>"
    else
        return "\<c-x>\<c-k>"
    endif
endfunction
" toggle tab completion
function! ToggleTabCompletion()
    if mapcheck("\<tab>", "i") != ""
        :iunmap <tab>
        :iunmap <s-tab>
        :iunmap <c-tab>
        echo "tab completion off"
    else
        :imap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
        :imap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr>
        :imap <c-tab> <c-r>=InsertTabWrapper ("startkey")<cr>
        echo "tab completion on"
    endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr>
inoremap <c-tab> <c-r>=InsertTabWrapper ("startkey")<cr>
map <Leader>tc :call ToggleTabCompletion()<cr>
" }}} ------------------------------------------------------------------------
" Key maps {{{
if (&term =~ "xterm") || (&term =~ "vt100")
    set t_kP=[5~
    set t_kN=[6~
    set t_kh=[1~
    set t_@7=[4~
endif
" }}} ------------------------------------------------------------------------
" Macro maps {{{
map Q gqq
nnoremap <silent> <F2> :bp!<CR>
nnoremap <silent> <F3> :bn!<CR>
nnoremap <silent> <F5> zm
nnoremap <silent> <F6> zr
nnoremap <silent> <F7> :set fdm=syntax<CR>
nnoremap <silent> <F8> zi
nnoremap <silent> <F9> :16vsp .<CR>:wincmd p<CR>
"nnoremap <silent> <F10> :wincmd h<CR>:q<CR>
map <F10> :set paste<CR>
map <F11> :set nopaste<CR>
imap <F10> <C-O>:set paste<CR>
imap <F11> <nop>
set pastetoggle=<F11>
" }}} ------------------------------------------------------------------------
" Folding {{{
" I use Johannes Zellner's way to do it, and some of his files
if (version >= 600) && has("autocmd") && has("folding")
    augroup folding
        au!
        au FileType * runtime fold/<amatch>-fold.vim
        au FileType * if &foldmethod != 'manual' | set foldcolumn=1 | else | set foldcolumn=0 | endif
    augroup END
endif
" }}} ------------------------------------------------------------------------

" vim600: set fdm=marker:
