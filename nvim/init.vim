"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      General NVIM settings                          "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use ! on function and command definitions to suppress warning
" on reload.
"
" This will automatically reload the vimfile on save.
" You can force it by doing :source % on the buffer that has this file
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Don't emulate vi bugs
set nocompatible
set shell=/bin/zsh
let $SHELL="/bin/zsh"
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

"""""""""""""""""""""""""""""""""""""""""""""""
"                   Plug                      "
"""""""""""""""""""""""""""""""""""""""""""""""
" filetype off

call plug#begin()

" Theme
Plug 'tiagovla/tokyodark.nvim'

"""""""""""
" Plugins "
"""""""""""

" LSP
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip', {',tag': 'v2.3.0', 'do': 'make install_jsregexp'}
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v3.x'}

" Repeat (Plug for plugins to use .)
Plug 'tpope/vim-repeat'

" gcc to (un)comment lines
Plug 'tpope/vim-commentary'

" Proc running
Plug 'Shougo/vimproc.vim', { 'do': 'make' }

" Paren, quotes, bracket editing
Plug 'tpope/vim-surround'

" NERD tree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Complementary pairing hotkeys & operations
" eg - ]q jumps to next in quicklist, [q for other way
"      ]space adds a new line below, [space adds new line above
Plug 'tpope/vim-unimpaired'

" Git
Plug 'tpope/vim-fugitive'

" Git-gutter
Plug 'airblade/vim-gitgutter'

" status line
"Plug 'bling/vim-airline'

" Vipe
Plug 'luan/vipe'

" Abolish
Plug 'tpope/tpope-vim-abolish'
"
" Tagbar
"Plug 'majutsushi/tagbar'

" Github Copilot
Plug 'github/copilot.vim'
" Needs :Copilot setup

" Plug 'supermaven-inc/supermaven-nvim'

" :lua vim.lsp.start({
"   name = 'my-server-name',
"   cmd = {'name-of-language-server-executable'},
"   root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml'}, { upward = true })[1]),
" })


"""""""""""""
" Languages "
"""""""""""""

" Carthage
Plug 'cfdrake/vim-carthage'

" Mustache
Plug 'juvenn/mustache.vim'

" Clojure
" Plug 'git://github.com/vim-scripts/paredit.vim.git'
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
"Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }
Plug 'liquidz/vim-iced', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }
Plug 'tpope/vim-salve', { 'for': 'clojure' }
Plug 'tpope/vim-projectionist', { 'for': 'clojure' }
Plug 'tpope/vim-dispatch', { 'for': 'clojure' }
Plug 'Olical/conjure', { 'for': 'clojure' }
" Plug 'kien/rainbow_parentheses.vim'


call plug#end()

filetype plugin indent on
syntax enable

let g:vimsyn_embed = 'l'
let g:loaded_perl_provider = 0

"""""""""""""""""""""""""""""""""""""""""""""""
"               KEY BINDINGS                  "
"""""""""""""""""""""""""""""""""""""""""""""""

" Special key for custom bindings
let mapleader = ","
let g:mapleader = ","

" fast editing of vimrc file
" ,v => edits current file
map <leader>v :e ~/.config/nvim/init.vim<CR>

" jump to previous buffer
noremap <leader><leader> <c-^>
map <c-c> <esc>

" Emacs keys for navigation
" Command Line
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>
cnoremap <c-bs> <c-w>
" Normal, Visual modes
" noremap <c-f> l
" noremap <c-b> h
" noremap <c-p> k
" noremap <c-n> j
" noremap <c-k> D
" Insert mode
inoremap <c-f> <esc>la
inoremap <c-b> <esc>ha
inoremap <c-k> <esc>Da
"noremap <c-a> <esc>^i
inoremap <c-e> <esc>$a
inoremap <c-bs> <c-w>

" quickfix hotkeys
noremap <leader>j :cn<cr>
noremap <leader>k :cp<cr>

" Suppress all whitespace at end of lines when saving
" But preserve repeat macro & cursor position
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
noremap <leader>w :call <SID>StripTrailingWhitespaces()<cr>:w<cr>

" tab-navigation
noremap <c-h> gT
noremap <c-l> gt
noremap <c-t> :tabnew<cr>
noremap <c-c> :tabclose<cr>

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

" Smart tabbing behavior
function! CleverTab()
    if pumvisible()
        return "\<C-N>"
    else
        let line_to_cursor = strpart( getline('.'), 0, col('.')-1 )
        if strlen( line_to_cursor ) == 0
            return "\<Tab>"
        elseif line_to_cursor =~ '\s\s*$'
            return "\<Tab>"
        elseif line_to_cursor =~ '/$'
            return "\<C-X>\<C-F>"
        elseif exists('&omnifunc') && &omnifunc != ''
            return "\<C-X>\<C-O>"
        else
            return "\<C-N>"
        endif
    endif
    " if coc#pum#visible()
    "     return coc#pum#next(1)
    " elseif pumvisible()
    "     return "\<C-N>"
    " else
    "     let line_to_cursor = strpart( getline('.'), 0, col('.')-1 )
    "     if strlen( line_to_cursor ) == 0
    "         return "\<Tab>"
    "     elseif line_to_cursor =~ '\s\s*$'
    "         return "\<Tab>"
    "     elseif line_to_cursor =~ '/$'
    "         return "\<C-X>\<C-F>"
    "     elseif exists('&omnifunc') && &omnifunc != ''
    "         return "\<C-X>\<C-O>"
    "     else
    "         return "\<C-N>"
    "     endif
    " endif
endfunction

function! CleverUnshiftTab()
    if pumvisible()
        return "\<C-p>"
    else
        return "\<\<"
    end
    " if coc#pum#visible()
    "     return coc#pum#prev(1)
    " elseif pumvisible()
    "     return "\<C-p>"
    " else
    "     return "\<\<"
    " end
endfunction

function! CleverReturn()
    if pumvisible()
        return "\<C-y>"
    else
        return "\<cr>"
    end
    " if coc#pum#visible()
    "     return coc#pum#confirm()
    " elseif pumvisible()
    "     return "\<C-y>"
    " else
    "     return "\<cr>"
    " end
endfunction

" Commented out to use nvim-cmp tab handling
" inoremap <silent><expr> <tab> CleverTab()
" inoremap <silent><expr> <s-tab> CleverUnshiftTab()
noremap <silent> td :tabclose<cr>

" disable highlighting when hitting the return or esc key
"inoremap <silent><script><expr> <CR> CleverReturn()
" inoremap <silent> <C-q> <Plug>(copilot-dismiss)
noremap <silent> <CR> :nohlsearch<cr><cr>

" Duplicate current line
noremap Y <esc>yyp

"let g:netrw_altv = 1
"let g:netrw_banner = 0
"let g:netrw_winsize = 20
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 0
"nmap <silent> \ :Lexplore<cr>
"nmap <silent> \| :Rexplore<cr>
" NERDTree toggle
 noremap \ :NERDTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""
"                CORE CONFIG                  "
"""""""""""""""""""""""""""""""""""""""""""""""

if $TMUX == ''
    set clipboard=unnamed  " System-like clipboard behavior if not in TMUX
endif

set notimeout          " Don't wait for timeout between command combinations

set nowrap             " no line wrapping
set textwidth=0        " width of document
set formatoptions-=t   " don't automatically wrap text when typing

set showmatch          " show paren matching

set scrolloff=3        " Keep more context when scrolling off the end of a buffer
set so=7               " move 7 lines when moving vertical
set magic              " Set for regular expressions' backslashes

" visualize invisible characters. Show spaces at the end of lines and tabs.
set list

set foldmethod=syntax  " code folding is determined by syntax
set foldlevel=99  " default fold level


""""""""""
" Search "
""""""""""

set ignorecase " that's case insensitive
set smartcase  " unless you type a capital letter
set wrapscan   " and the search wraps around the file

" make tab completion for files/buffers act like bash, but ignore sets of files
set wildignore=*.o,*.obj,*/.git/*,.svn,.cvs,*.rbc,*.pyc,*.class,*.jar,*.a
set wildignore+=**/.stack-work/**
set wildignore+=**/build/**
set wildignore+=**/dist/**
set wildignore+=**/.ropeproject/**
set wildignore+=**/node_modules/**
set wildmode=longest:full:list

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
set complete=.,w,b,d,t

" menu => Show menu when multiple autocomplete items are available
" preview => Show extra info about the currently selected completion in menu
" menuone => Shows menu when only one item is available for autocomplete
" longest => Only inserts longest common text for matches
" set completeopt=menu,preview
set completeopt=menuone,noinsert,noselect,preview

set noinfercase  " autocomplete without being case sensitive

""""""""""""""""""""""""
" Files, Backups, Undo "
""""""""""""""""""""""""

set ffs=unix,dos,mac " default line endings

set undolevels=9000  " undo history

" auto reload vimrc when edited
augroup vim_autoreload
    autocmd!
    autocmd bufwritepost .vimrc source ~/.vimrc
augroup END

" vim's backup / swap system
" disable all swap, backup and writebackups
set nobackup     " no backups
set writebackup  " except when writing files
set noswapfile   " no swapfiles

" Persistent undo
try
    if has('win32')
        set undodir=C:\Windows\Temp
    endif
    set undofile
catch
endtry

set virtualedit=all            " let cursor stray beyond textfile bounds

" Auto save buffers when focus is lost
au FocusLost * silent! :wa
" Auto save when switching buffers
set autowrite
" remember marks & undos for background buffers
set hidden

set nu rnu " enable relative line numbers
set numberwidth=5

" Set encoding and language
set fileencoding=utf-8

autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exec "normal g`\"" |
    \ endif

"""""""
" GUI "
"""""""

" Customized titlebar, filename with 3 parent directories
auto BufEnter * let &titlestring=expand("%:p:h:h:h:t") . "/" . expand("%:p:h:h:t") . "/" . expand("%:p:h:t") . "/" . expand("%:p:t") . " - Vim"

" stylize the cursor in different modes
set guicursor=n-v-c:block-Cursor
set guicursor+=ve:ver35-Cursor
set guicursor+=i:blinkon0
set guicursor+=i:ver25-Cursor/lCursor

" Command bar height
set cmdheight=1

" No sound on errors or visual bells
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set lazyredraw      " don't redraw when running macros
set shortmess=aOstTCF " shortens messages to avoid 'press a key' prompt

" show matching parens, brackets and braces
set showmatch
set matchtime=1

if has("gui_running")
    " disable toolbar & scrollbars
    set guioptions-=T
    set guioptions-=L
    set guioptions-=r

    set nospell

    if has('win32')
        " alt key jumps to menu
        set winaltkeys=menu
    end

    if has('macunix')
        set guifont=SF_Mono_Light:h13
    end
endif

" Equalize window sizes when a window is removed
set equalalways

" highlight the line the cursor is on (can be slow for large files)
set cursorline

" Experiemental performance improvements
set scrolljump=3
syntax sync minlines=50

"""""""""
" Theme "
"""""""""

"function! OverrideColorScheme() abort
"    highlight Pmenu      ctermfg=250 ctermbg=237 guifg=#c5c8c6 guibg=#373b41
"    highlight PmenuSel   cterm=reverse ctermfg=250 ctermbg=237 gui=reverse guifg=#c5c8c6 guibg=#373b41 blend=0
"    highlight PmenuThumb guibg=NvimDarkGrey4
"endfunction
"
"augroup color_customizations
"    autocmd!
"    autocmd ColorScheme * call OverrideColorScheme()
"augroup END

let &t_Co=256
colorscheme tokyodark
" set background=dark

augroup color_customizations
    autocmd!
    if has('gui_running')
        autocmd ColorScheme * highlight CursorLine guibg=#292929
        autocmd ColorScheme * highlight LineNr guifg=Grey30 guibg=NONE
    else
        autocmd ColorScheme * highlight LineNr ctermfg=233 ctermbg=None
    endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""
"        CUSTOM FUNCTIONS / COMMANDS          "
"""""""""""""""""""""""""""""""""""""""""""""""
command! ConvertToUTF8 :set encoding=utf-8 fileencodings=.

" Rename current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'))
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        exec '<c-^>:bw'
        redraw!
        exec ":echom \"Renamed " . old_name . " to " . new_name . "\""
    endif
endfunction
map <leader>R :call RenameFile()<cr>

function! DeleteFile()
    call inputsave()
    let file_name = input('Delete: ', expand('%'), "file")
    if empty(file_name)
        echo "Canceled"
    else
        call inputrestore()
        exec ':silent !rm ' . file_name
        exec ':silent bw'
        redraw!
        exec ":echom \"Deleted " . file_name . "\""
    endif
endfunction
map <leader>d :call DeleteFile()<cr>

function! FindSymbol()
    call inputsave()
    let curr = expand("<cword>")
    let symbol = input('Find Symbol (default: ' . curr . '): ')
    call inputrestore()
    if symbol == ""
        let query = curr
    else
        let query = symbol
    endif
    exec ':cs find s ' . query
endfunction
nmap <silent><nowait> <leader>s :call FindSymbol()<cr>

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

noremap <silent> <c-q> :call ToggleQuickFix()<cr>


"""""""""""""""""
" Running Tests "
"""""""""""""""""
function! RunIfMatchesFileOrVipe(command, file_ext_regex, append_file_as_arg)
    let in_runnable_file = match(expand("%:p"), a:file_ext_regex) != -1
    if in_runnable_file
        let t:last_ran_file=@%
    elseif !exists("t:last_ran_file")
        return 0
    elseif match(expand("%"), a:file_ext_regex) == -1
        return 0
    end

    :silent w
    if a:append_file_as_arg
        return RunCommandOrVipe(a:command . t:last_ran_file)
    else
        return RunCommandOrVipe(a:command)
    endif
endfunction

function! RunIfMatchesFile(command, file_ext_regex, append_file_as_arg)
    let in_runnable_file = match(expand("%:p"), a:file_ext_regex) != -1
    if in_runnable_file
        let t:last_ran_file=expand("%:p")
    elseif !exists("t:last_ran_file")
        return 0
    elseif match(expand("%:p"), a:file_ext_regex) == -1
        return 0
    end

    ":silent w
    if a:append_file_as_arg
        return RunCommand(a:command . t:last_ran_file)
    else
        return RunCommand(a:command)
    endif
endfunction

function! RunCommandOrVipe(command)
    " :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo
    " :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo
    " :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo
    " :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo
    " :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo
    if filereadable(vipe#pipe_path())
        exec ":Vipe " . a:command
        return 1
    else
        exec ":!" . a:command
        return 1
    end
endfunction

function! RunCommand(command)
    echo a:command
    exec a:command
    return 1
endfunction

function! RunTestFileIfPossible()
    let t:skip_file_check=0
    let has_ran=0
    " Ruby
    if !has_ran && filereadable("Gemfile")
        let has_ran = RunIfMatchesFileOrVipe("bundle exec rspec ", '\(.feature|_spec.rb\)$', 1)
    elseif !has_ran && executable('rspec')
        let has_ran = RunIfMatchesFileOrVipe("rspec ", '\(.feature|_spec.rb\)$', 1)
    endif
    " Python
    if !has_ran && executable('py.test') == 1
        let has_ran = RunIfMatchesFile("py.test ", '.*\/test.*.py$', 1)
    elseif !has_ran && executable('nosetests') == 1
        let has_ran = RunIfMatchesFile("nosetests ", '.*\/test.*.py$', 1)
    endif

    if !has_ran && executable("go") == 1
        let has_ran = RunIfMatchesFile("go test ./...", '.*test\.go$', 0)
    endif

    if !has_ran && (filereadable("Makefile") || filereadable("makefile"))
        " :!clear && make test
        let has_ran = RunCommandOrVipe('make test')
    endif

    if !has_ran
        echom "Failed to discover test runner. Please bind manually."
    endif
endfunction

nnoremap <leader>t :call RunTestFileIfPossible()<cr>
nnoremap <leader>T :call RunTestsIfPossible()<cr>


"""""""""""""""""""""""""""""""""""""""""""""""
"                LANG CONFIG                  "
"""""""""""""""""""""""""""""""""""""""""""""""

" Copilot
"let g:copilot_no_tab_map = v:true

""""""""""""
" Defaults "
""""""""""""
set expandtab          " use spaces for tab key
set cindent            " be smart for indenting a new line
set shiftround         " round indent to multiple of shiftwidth

set shiftwidth=4       " indent amounts
set tabstop=4          " how long a tab is represented
set softtabstop=4      " how many spaces to delete when backspacing

augroup language_customizations
    " clear old defs
    autocmd!
    autocmd FileType python setlocal expandtab
    " cindent instead of smartindent to not force hashes going to beginning of line
    " for python comments, that's annoying
    autocmd FileType python setlocal cindent

    " RegExp to find file names + line numbers in quickfix window
    autocmd FileType python setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

    autocmd FileType ruby setlocal expandtab
    autocmd FileType ruby setlocal tabstop=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd BufRead,BufNewFile Podfile set filetype=ruby

    autocmd FileType javascript setlocal expandtab
    autocmd FileType javascript setlocal tabstop=2
    autocmd FileType javascript setlocal softtabstop=2
    autocmd FileType javascript setlocal shiftwidth=2
    autocmd FileType tsx setlocal expandtab
    autocmd FileType tsx setlocal tabstop=2
    autocmd FileType tsx setlocal softtabstop=2
    autocmd FileType tsx setlocal shiftwidth=2
    autocmd FileType ts setlocal expandtab
    autocmd FileType ts setlocal tabstop=2
    autocmd FileType ts setlocal softtabstop=2
    autocmd FileType ts setlocal shiftwidth=2
    autocmd FileType yaml setlocal tabstop=2
    autocmd FileType yaml setlocal softtabstop=2
    autocmd FileType yaml setlocal shiftwidth=2
    autocmd FileType yaml setlocal expandtab

    autocmd FileType sls setlocal tabstop=4
    autocmd FileType sls setlocal softtabstop=4
    autocmd FileType sls setlocal shiftwidth=4
    autocmd FileType sls setlocal expandtab

    " golang
    autocmd FileType go setlocal noexpandtab
    autocmd FileType go setlocal tabstop=4
    autocmd FileType go setlocal softtabstop=4
    autocmd FileType go setlocal shiftwidth=4
    autocmd BufWritePost *.templ silent! execute "!PATH=\"$PATH:$(go env GOPATH)/bin\" templ fmt <afile> >/dev/null 2>&1" | redraw!

     autocmd FileType go setlocal efm=%E%.%#FAIL:\ %m,%C%.%#:[0-9]%#:\ %m,%C%.%#\ %f:%l,%Z%.%#stacktrace:\ %#%f:%l,%-G%.%#,#E%f:%l:\ %m
" --- FAIL: TestCanNegotiateEncryptedSessionConnection (0.06 seconds)
" 	expectations.go:71: expected &protocol.packetBuffer{packets:[]interface {}{}, wUpgrader:(protocol.WriterFactory)(nil), rUpgrader:(protocol.ReaderFactory<...>ol.packetBuffer{packets:[]interface {}{}, wUpgrader:(protocol.WriterFactory)(nil), rUpgrader:(protocol.ReaderFactory)(nil)} (*protocol.packetBuffer) No packets to read!
" 		 stacktrace: /Users/jeff/workspace/mc/src/mc/protocol/connection_test.go:246
" 		                 inside mc/protocol.TestCanNegotiateEncryptedSessionConnection
" 		             /Users/jeff/.gvm/gos/go1.1/src/pkg/testing/testing.go:354
" 		                 inside testing.tRunner
" 		             /Users/jeff/.gvm/gos/go1.1/src/pkg/runtime/proc.c:1223


    autocmd FileType html setlocal tabstop=2
    autocmd FileType html setlocal softtabstop=2
    autocmd FileType html setlocal shiftwidth=2
    autocmd FileType html setlocal noexpandtab

    autocmd FileType css setlocal noexpandtab
    autocmd FileType css setlocal tabstop=2
    autocmd FileType css setlocal softtabstop=2
    autocmd FileType css setlocal shiftwidth=2

    autocmd FileType clojure set lisp

    " make requires tabs
    autocmd FileType make setlocal noexpandtab
    autocmd FileType make setlocal nosmartindent

    autocmd FileType php setlocal noexpandtab

    " autocmd FileType yaml SupermavenStop
    " autocmd FileType json SupermavenStop
    " autocmd FileType fish SupermavenStop
    " autocmd FileType bash SupermavenStop
    autocmd FileType yaml Copilot disable
    autocmd FileType json Copilot disable
    autocmd FileType fish Copilot disable
    autocmd FileType bash Copilot disable
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""
"              PLUGIN CONFIG                  "
"""""""""""""""""""""""""""""""""""""""""""""""

""""""""""
" Python "
""""""""""
let python_highlight_all = 1
let python_syntax_slow_sync = 0
let python_highlight_builtin_objs = 1
let python_highlight_builtin_funcs = 1
let g:pymode_doc = 0
let g:pymode_lint = 0
let g:pymode_lint_on_write = 0
let g:pymode_rope = 1
let g:pymode_rope_auto_project = 1


"""""""""""
" Clojure "
"""""""""""
" HighlightBuiltins doesn't work....
augroup clojure_customizations
    autocmd!
    autocmd Filetype clojure highlight link ClojureSpecial Define
augroup END

" Rainbow parens
" autocmd VimEnter * RainbowParenthesesToggle
" autocmd Syntax * RainbowParenthesesLoadRound
" autocmd Syntax * RainbowParenthesesLoadSquare
" autocmd Syntax * RainbowParenthesesLoadBraces

"""""""""""""""
"  Telescope  "
"""""""""""""""
nnoremap <Leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>G <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>m <cmd>Telescope marks<cr>
nnoremap <leader>s <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
nnoremap <leader>S <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>gd <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>gr <cmd>Telescope lsp_references<cr>
nnoremap <leader>gi <cmd>Telescope lsp_implementations<cr>

"""""""""


lua <<EOF
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
        }),
        window = {
            completion = {
                winhighlight = "Normal:Pmenu",
            },
            documentation = {
                winhighlight = "Normal:Pmenu",
            }
        }
    })

    local lsp_zero = require('lsp-zero')

    -- require('supermaven-nvim').setup({})

    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            "bash",
            "c",
            "clojure",
            "cpp",
            "css",
            "csv",
            "diff",
            "elixir",
            "fish",
            "go",
            "gomod",
            "gosum",
            "gotmpl",
            "haskell",
            "hcl",
            "html",
            "javascript",
            "json",
            "jsonnet",
            "lua",
            "make",
            "markdown",
            "markdown_inline",
            "nix",
            "odin",
            "proto",
            "python",
            "ruby",
            "rust",
            "scss",
            "sql",
            "templ",
            "terraform",
            "tmux",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
            "zig",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
        },
        additional_vim_regex_highlighting = false,
    }

    lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})

    -- Disable built-in completion to avoid conflicts with nvim-cmp
    vim.bo[bufnr].omnifunc = nil
    end)

    require('mason').setup({})
    require('mason-lspconfig').setup({
        ensure_installed = {
            'cssmodules_ls',
            'dockerls',
            'elixirls',
            'gopls',
            'html',
            'htmx',
            'jsonls',
            'templ',
            'tailwindcss',
            "ts_ls",
        },
        handlers = {
            lsp_zero.default_setup,
        },
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = {"*.ts", "*.tsx"},
        callback = function()
            local params = vim.lsp.util.make_range_params()
            params.context = {only = {"source.organizeImports"}}
            -- buf_request_sync defaults to a 1000ms timeout. Depending on your
            -- machine and codebase, you may want longer. Add an additional
            -- argument after params if you find that you have to write the file
            -- twice for changes to be saved.
            -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
            for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
            end
            vim.lsp.buf.format({async = false})
        end
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
            local params = vim.lsp.util.make_range_params()
            params.context = {only = {"source.organizeImports"}}
            -- buf_request_sync defaults to a 1000ms timeout. Depending on your
            -- machine and codebase, you may want longer. Add an additional
            -- argument after params if you find that you have to write the file
            -- twice for changes to be saved.
            -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
            for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
            end
            vim.lsp.buf.format({async = false})
        end
    })

    vim.filetype.add({ extension = { templ = "templ" } })


    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Disable omnifunc to prevent conflicts with nvim-cmp
        -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
    })
EOF
