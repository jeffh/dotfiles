" General VIM settings
" Use ! on function and command definitions to suppress warning
" on reload.
"
" This will automatically reload the vimfile on save.
" You can force it by doing :source % on the buffer that has this file
" =============

" Don't emulate vi bugs
set nocompatible

" load pathogen (package manager)
silent call pathogen#infect()
"call pathogen#helptags()

" Special key for custom bindings
let mapleader = ","
let g:mapleader = ","

" fast editing of vimrc file
" ,v => edits current file
map <leader>v :e ~/.vimrc<CR>
" Customized titlebar, filename with 3 parent directories
auto BufEnter * let &titlestring=expand("%:p:h:h:h:t") . "/" . expand("%:p:h:h:t") . "/" . expand("%:p:h:t") . "/" . expand("%:p:t") . " - Vim"

set laststatus=2

" switch buffers
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

" File Explorer
"nmap <leader>e :Ex<cr>
"nmap <leader>s :Sex<cr>

" Save
nmap <leader>w :w<cr>

" ctags
" go to defn of tag under the cursor
" Make it case sensitive when doing so
fun! MatchCaseTag()
    let ic = &ic
    set noic
    try
        exe 'tjump ' . expand('')
    finally
       let &ic = ic
    endtry
endfun
command! GenerateTags :!/usr/local/bin/ctags --python-kinds=-iv --exclude=build --exclude=dest -f .tags -R .

" Always update before jumping to symbol
"nnoremap <c-]> :call MatchCaseTag()<cr>
" Search tags
nnoremap <leader>t :GenerateTags<cr>
set tags=./.tags;$HOME


" No timeout between command combinations
set notimeout

" ============= Tabbing / Indentation / Autocomplete / Wrapping

" no line wrapping
set nowrap
" no automatic wrapping (inserting \n) of text your type
set textwidth=0

set expandtab
set autoindent
set smarttab
set smartindent
set shiftround

set shiftwidth=4
set tabstop=4
set softtabstop=4

set showmatch

" Language-specific tabbing
autocmd FileType html setlocal tabstop=2
autocmd FileType html setlocal shiftwidth=2
autocmd FileType html setlocal noexpandtab

autocmd FileType javascript setlocal noexpandtab

autocmd FileType clojure set lisp

" cindent instead of smartindent to not force hashes going to beginning of line
" for python comments, that's annoying
autocmd FileType python setlocal cindent

autocmd FileType make setlocal noexpandtab

set complete=.,w,b,u,U,t,i,t
set noinfercase

set list
set listchars=tab:\|\ ,trail:·,

set foldmethod=syntax
" autocmd FileType <Syntax> setlocal foldmethod=syntax

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

colorscheme twilight

" highlight the line the cursor is on
set cursorline

" Colors
if has('gui_running')
    highlight CursorLine   guibg=#292929
    highlight StatusLine   guifg=Grey20   guibg=white
    highlight StatusLineNC guifg=Grey10   guibg=Grey50
    " guibg=NONE so we get the nice transparency stuff
    highlight LineNr       guifg=Grey40   guibg=NONE
else
    highlight LineNr       ctermfg=DarkGrey    ctermbg=None
    highlight StatusLine   ctermfg=Grey        ctermbg=Black
    highlight Search       ctermfg=DarkYellow  ctermbg=Black
    highlight Pmenu        ctermfg=White       ctermbg=DarkGrey
    highlight PmenuSel     ctermfg=White       ctermbg=DarkRed
endif

" --------------- Python syntax highlighting
" hi link pythonParamName Function
" custom python.vim syntax file
"au! Syntax python source ~/.vim/syntax/python.vim
let g:pymode_lint_write = 0
"map <c-t> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
"\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
"\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" ============= Commands
command! ConvertTabsToSpaces :set expandtab|retab
command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g
command! ConvertSpacesToTab :'<,'>SuperRetab 4
command! ConvertToUTF8 :set encoding=utf-8 fileencodings=.

set ofu=syntaxcomplete#Complete

" ============= Search

set incsearch
set ignorecase
set smartcase
set wrapscan

" highlight search results
set hlsearch

" disable highlighting when hitting the return or esc key
"nnoremap <ESC> :nohlsearch<esc>
"nnoremap <return> :noh<cr><return>

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
set nobackup
set writebackup

" CommandT plugin config
let g:CommandTMaxHeight=20
let g:CommandTMatchWindowAtTop=0
let g:CommandTMatchWindowReverse=1
map <leader>f :CommandTFlush<CR>\|:CommandT<CR>

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

" Set shell
if has('macunix') || has('mac')
  set shell=/bin/bash
  "elseif has('win32')
elseif has('unix')
  set shell=/bin/bash
endif

" ============= Editing
set autoread " auto refresh files that were changed

" Let the cursor stray beyond the normal text bounds
set virtualedit=all
" backspace behaves like normal sane apps
set backspace=eol,indent,start

" Auto save buffers when focus is lost
au FocusLost * silent! :wa
" Auto save when switching buffers
set autowrite
" remember marks & undos for background buffers
set hidden

" use open buffer when possible which switching
set switchbuf=useopen

" enable line numbers
set number
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

" default line endings
if has('macunix') || has('mac')
  set ffs=unix,mac,dos
elseif has('win32')
  set ffs=dos,unix,mac
elseif has('unix')
  set ffs=unix,mac,dos
endif

" command line history
set history=600

" Suppress all spaces at end of lines when saving
autocmd BufWritePre * :%s/^\s\+$//e

" Keep more context when scrolling off the end of a buffer
set scrolloff=3

" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<CR>
inoremap <s-tab> <c-n>

noremap Y <esc>yyp

" ============= Visual / GUI

" Command bar height
set cmdheight=1

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

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
set wildignore+=*.o,*.obj,.git,.svn,.cvs,*.rbc,*.pyc
set wildmode=longest:full:list
set wildmenu

if has("gui_running")
  " disable toolbar & scrollbars
  set guioptions-=T
  set guioptions-=L
  set guioptions-=r

  set spell

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

" =============== Utilities

" From Gary - https://www.destroyallsoftware.com/file-navigation-in-vim.html
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('Rename to: ', expand('%'))
  if new_name != '' && new_Name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm' . old_name
    redraw!
  endif
endfunction
map <leader>r :call RenameFile()<cr>

function! DeleteFile(...)
  if(exists('a:1'))
    let theFile=a:1
  elseif ( &ft == 'help' )
    echohl Error
    echo "Cannot delete a help buffer!"
    echohl None
    return -1
  else
    let theFile=expand('%:p')
  endif
  let delStatus=delete(theFile)
  if(delStatus == 0)
    echo "Deleted " . theFile
  else
    echohl WarningMsg
    echo "Failed to delete " . theFile
    echohl None
  endif

  echo theFile . " was deleted!"
  return delStatus
endfunction
"delete the current file
command! Rm call DeleteFile()
command! DeleteFile call DeleteFile()

" =============== misc

if version >= 700 && has('python')
  autocmd FileType python set omnifunc=pythoncomplete#Complete
  let Tlist_Ctags_Cmd='/usr/bin/ctags'
endif

" spacing in various languages
augroup myfiletypes
  " clear old defs
  autocmd!
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et
augroup END

" ===================== HACKS
" create extra buffer to prevent commandT from complaining
" when we try to open something on the last buffer
badd *scratch*

" ===================== JS Indent (web-indent)
let g:js_indent_log = 0 " disable logging
