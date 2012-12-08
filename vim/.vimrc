" General VIM settings
" Use ! on function and command definitions to suppress warning
" on reload.
"
" This will automatically reload the vimfile on save.
" You can force it by doing :source % on the buffer that has this file
" =============

" Don't emulate vi bugs
set nocompatible

" Special key for custom bindings
let mapleader = ","
let g:mapleader = ","

" System-like clipboard behavior
set clipboard=unnamed

" fast editing of vimrc file
" ,v => edits current file
map <leader>v :e ~/.vimrc<CR>
" Customized titlebar, filename with 3 parent directories
auto BufEnter * let &titlestring=expand("%:p:h:h:h:t") . "/" . expand("%:p:h:h:t") . "/" . expand("%:p:h:t") . "/" . expand("%:p:t") . " - Vim"

set laststatus=2

" jump to previous buffer
noremap <leader><leader> <c-^>

" Emacs keys for navigation
" Command Line
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>
cnoremap <c-bs> <c-w>
" Normal, Visual modes
"noremap <c-a> ^
"noremap <c-e> $
noremap <c-f> l
noremap <c-b> h
noremap <c-p> k
noremap <c-n> j
noremap <c-k> D
" Insert mode
inoremap <c-f> <esc>la
inoremap <c-b> <esc>ha
inoremap <c-k> <esc>Da
"noremap <c-a> <esc>^i
inoremap <c-e> <esc>$a
inoremap <c-bs> <c-w>

" Suppress all whitespace at end of lines when saving
noremap <leader>w :%s/\s\+$//e<cr>:w<cr>

" tab-navigation
noremap <c-h> gT
noremap <c-l> gt
noremap <c-t> :tabnew<cr>
noremap <c-c> :tabclose<cr>

" indenting
"vnoremap < <gv
"vnoremap > >gv

" Search tags
set tags=./.tags;$HOME


" No timeout between command combinations
set notimeout

" ============= Tabbing / Indentation / Autocomplete / Wrapping

set nowrap             " no line wrapping
set textwidth=0        " width of document
set formatoptions-=t   " don't automatically wrap text when typing

set expandtab          " use spaces for tab key
set autoindent         " automatically detect how to indent
set smarttab           " be smart to how much to indent
set smartindent        " be smart for indenting a new line
set shiftround         " round indent to multiple of shiftwidth

set shiftwidth=4       " indent amounts
set tabstop=4          " how long a tab is represented
set softtabstop=4      " how many spaces a tab is (with expandtab)

set switchbuf="usetab" " buffer switching behavior - use tab or window if available

set showmatch          " show paren matching

" Language-specific tabbing
autocmd FileType html setlocal tabstop=2
autocmd FileType html setlocal shiftwidth=2
autocmd FileType html setlocal noexpandtab

autocmd FileType javascript setlocal noexpandtab

autocmd FileType clojure set lisp

" cindent instead of smartindent to not force hashes going to beginning of line
" for python comments, that's annoying
autocmd FileType python setlocal cindent

" make requires tabs
autocmd FileType make setlocal noexpandtab
autocmd FileType make setlocal nosmartindent

autocmd FileType php setlocal noexpandtab
autocmd FileType php setlocal foldmethod=indent

" where <C-P> should get it's completion list
" . => current buffer
" w => buffers from other windows
" b => loaded buffers in buffer list
" u => unloaded buffers in buffer list (can be unreliable)
" U => buffers not in buffer list (can be unreliable)
" k => dictionary
" kspell => spell checking
" s => thesaurus
" i => scan current & included files
" d => scan current & included files for defined name or macro
" ] => tag completion
" t => alias for ]
set complete=.,w,b,t,d,i,t

" menu => Show menu when multiple autocomplete items are available
" preview => Show extra info about the currently selected completion in menu
" menuone => Shows menu when only one item is available for autocomplete
" longest => Only inserts longest common text for matches
set completeopt=menu,preview

set noinfercase  " autocomplete without being case sensitive

" visualize invisible characters. Show spaces at the end of lines and tabs.
set list
set listchars=tab:\|\ ,trail:·,

set foldmethod=syntax  " code folding is determined by syntax
set foldlevelstart=20  " default fold level

" ============= Syntaxes / Highlighting

let python_highlight_all = 1
let python_slow_sync = 1
let python_highlight_builtin_objs = 1
let python_highlight_builtin_funcs = 1

" clojure
let g:vimclojure#HighlightBuiltins=1
let g:vimclojure#ParenRainbow=1
let g:vimclojure#FuzzyIndent=1
let g:vimclojure#DynamicHighlighting=1

" HighlightBuiltins doesn't work....
autocmd Filetype clojure highlight link ClojureSpecial Define

filetype plugin indent on

syntax enable

" -------------- Styles

colorscheme jellybeans
"colorscheme twilight

" highlight the line the cursor is on
"set cursorline

" for twilight Colors
if has('gui_running')
    highlight CursorLine   guibg=#292929
    highlight StatusLine   guifg=Grey   guibg=NONE
    highlight StatusLineNC guifg=Grey10   guibg=Grey50
    " guibg=NONE so we get the nice transparency stuff
    highlight LineNr       guifg=Grey30   guibg=NONE
    highlight Search                      guibg=NONE     gui=underline
else
    highlight LineNr       ctermfg=DarkGrey    ctermbg=None
    highlight StatusLine   ctermfg=Grey        ctermbg=Black
    highlight StatusLineNC ctermfg=DarkGrey    ctermbg=Black
    highlight VertSplit    ctermfg=Black       ctermbg=Black
    highlight Pmenu        ctermfg=White       ctermbg=DarkGrey
    highlight PmenuSbar                        ctermbg=Yellow
    highlight PmenuThumb                       ctermbg=Black
    highlight PmenuSel     ctermfg=Black       ctermbg=Yellow
    highlight Search       ctermfg=None        ctermbg=NONE      cterm=underline
endif

" --------------- Python syntax highlighting
" hi link pythonParamName Function
" custom python.vim syntax file
"au! Syntax python source ~/.vim/syntax/python.vim
let g:pymode_lint_write = 0
"map <c-t> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
"\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
"\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
let g:pymode_rope = 1
let g:pymode_rope_auto_project = 1

" ============= Commands
command! ConvertTabsToSpaces :set expandtab|retab
command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g
command! ConvertSpacesToTab :'<,'>SuperRetab 4
command! ConvertToUTF8 :set encoding=utf-8 fileencodings=.

set ofu=syntaxcomplete#Complete

" ============= Search

set hlsearch   " highlight search results
set incsearch  " incremental search
set ignorecase " that's case insensitive
set smartcase  " unless you type a capital letter
set wrapscan   " and the search wraps around the file

" disable highlighting when hitting the return or esc key
nnoremap <CR> :nohlsearch<cr><cr>
"nnoremap <Esc> :nohlsearch<Esc>

" Type %/ or %? in command line to expand out to current buffer's file location
" (if it exists)
if has('unix')
    cnoremap %/ <C-R>=expand("%:h") . "/" <CR>
    cnoremap %? <C-R>=expand("%:h") . "/" <CR>
    cnoremap %% <C-R>=expand("%:h") . "/" <CR>
else
    cnoremap %/ <C-R>=expand("%:h") . "\\" <CR>
    cnoremap %? <C-R>=expand("%:h") . "\\" <CR>
    cnoremap %% <C-R>=expand("%:h") . "\\" <CR>
endif

" ============= Files, Backups, Undo

" auto reload vimrc when edited
autocmd! bufwritepost .vimrc source ~/.vimrc

" vim's backup / swap system
set backupdir=~/.vim/tmp/,~/.tmp,/var/tmp,/tmp
set directory=~/.vim/tmp/,~/.tmp,/var/tmp,/tmp
" disable all swap, backup and writebackups
set nobackup     " no backups
set writebackup  " except when writing files
set noswapfile   " no swapfiles

" CtrlP plugin config
"map <leader>f :CtrlPMixed<cr>
let g:ctrlp_map = '<leader>f'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'rc'

" Use templates when creating new files of same extensions
augroup templates
    au!
    autocmd BufNewFile *.* silent! execute '0r ~/.vim/skel/tmpl.'.expand('<afile>:e')
    autocmd BufNewFile * %substitute#\[:EVAL:\]\(.\{-\}\)\[:END:\]#\=eval(submatch(1))#ge
    autocmd BufNewFile * silent! foldopen!
augroup END
" but make sure a buffer with the template file isn't opened
set cpoptions-=a

" Persistent undo
try
    if has('win32')
        set undodir=C:\Windows\Temp
    else
        set undodir=/tmp/vim_undodir
    endif
    set undofile
catch
endtry

" ============= Editing
set autoread                   " auto refresh files that were changed
set virtualedit=all            " let cursor stray beyond textfile bounds
set backspace=eol,indent,start " backsapce behaves like normal program

" Auto save buffers when focus is lost
au FocusLost * silent! :wa
" Auto save when switching buffers
set autowrite
" remember marks & undos for background buffers
set hidden

set number " enable line numbers
"set numberwidth=5

" Set encoding and language
set encoding=utf8
try
    lang en_US
catch
endtry

" stylize the cursor in different modes
set guicursor=n-v-c:block-Cursor
set guicursor+=i:block-Cursor
set guicursor+=i:blinkon0

set ffs=unix,dos,mac " default line endings

set history=600      " command line history
set undolevels=9000  " undo history

" Suppress all spaces at end of lines when saving
"autocmd BufWritePre * :%s/^\s\+$//e

" Keep more context when scrolling off the end of a buffer
set scrolloff=3

"function! CleverTab()
"    if pumvisible()
"        return "\<C-N>"
"    endif
"    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
"        "return "\<Tab>"
"        return "<c-r>=TriggerSnippet()<cr>"
"    elseif exists('&omnifunc') && &omnifunc != ''
"        return "\<C-X>\<C-O>"
"    else
"        return "\<C-N>"
"    endif
"endfunction
"inoremap <tab> <c-r>=CleverTab()<CR>
"inoremap <s-tab> <C-p>

noremap Y <esc>yyp

" ============= Visual / GUI

" Command bar height
set cmdheight=1

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set vb

set lazyredraw " don't redraw when running macros
set shortmess=aOstT " shortens messages to avoid 'press a key' prompt

" show matching parens, brackets and braces
set showmatch
set matchtime=1

" Display cursor location info in the bottom right of status bar
set ruler

set so=7 " move 7 lines when moving vertical
set magic " Set for regular expressions' backslashes

" make tab completion for files/buffers act like bash, but ignore sets of files
set wildignore+=*.o,*.obj,*/.git/*,.svn,.cvs,*.rbc,*.pyc
set wildignore+=*/build/*
set wildignore+=*/dist/*
set wildignore+=*/.ropeproject/*
set wildmode=longest:full:list
set wildmenu

if has("gui_running")
    " disable toolbar & scrollbars
    set guioptions-=T
    set guioptions-=L
    set guioptions-=r

    set nospell

    set guifont=Inconsolata-dz:h14
    if has('win32')
        " alt key jumps to menu
        set winaltkeys=menu
    end
    if has('macunix')
        set transparency=5
    end
endif

" make active window larger
set winwidth=84
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=10
set winminheight=10
set winheight=999

" =============== misc

" autocomplete
if version >= 700
    autocmd FileType python set omnifunc= "pythoncomplete#Complete
    autocmd FileType javascript set omnifunc= "javascriptcomplete#CompleteJS
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType php set omnifunc=phpcomplete#CompletePHP
    autocmd FileType c set omnifunc=ccomplete#Complete
    autocmd FileType go setlocal tabstop=4
    autocmd FileType go setlocal softtabstop=4
    let Tlist_Ctags_Cmd='/usr/bin/ctags'
endif

" spacing in various languages
augroup myfiletypes
    " clear old defs
    autocmd!
    autocmd FileType ruby,haml,eruby,html,javascript,sass set ai sw=2 sts=2 et
    autocmd FileType python set sw=4 sts=4 et
augroup END

" ===================== HACKS
" create extra buffer to prevent commandT from complaining
" when we try to open something on the last buffer
"badd *scratch*

" ===================== JS Indent (web-indent)
let g:js_indent_log = 0 " disable logging

" load pathogen (package manager)
silent call pathogen#infect()
call pathogen#helptags()

" ===================== SuperTab
let g:SuperTabDefaultCompletionType = "context"

" ===================== Jedi-Vim
let g:jedi#popup_on_dot = 0
