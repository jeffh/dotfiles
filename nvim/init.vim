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
Plug 'w0ng/vim-hybrid'

"""""""""""
" Plugins "
"""""""""""

" LSP
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
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
" Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Find Replace

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
Plug 'majutsushi/tagbar'

" Github Copilot
Plug 'github/copilot.vim'
" Needs :Copilot setup

" :lua vim.lsp.start({
"   name = 'my-server-name',
"   cmd = {'name-of-language-server-executable'},
"   root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml'}, { upward = true })[1]),
" })


"""""""""""""
" Languages "
"""""""""""""


" Ansible YAML
Plug 'chase/vim-ansible-yaml'

" Carthage
Plug 'cfdrake/vim-carthage'

" Dart
Plug 'dart-lang/dart-vim-plugin'

" Markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" Nix
Plug 'LnL7/vim-nix'

" Elm
Plug 'elmcast/elm-vim'

" Elixir
Plug 'elixir-editors/vim-elixir'

" Odin
Plug 'Tetralux/odin.vim'

" Terraform
Plug 'hashivim/vim-terraform'

" HCL
Plug 'jvirtanen/vim-hcl'

" Mustache
Plug 'juvenn/mustache.vim'

" Google Go (golang)
" Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" Clojure
" Plug 'git://github.com/vim-scripts/paredit.vim.git'
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }
Plug 'tpope/vim-salve', { 'for': 'clojure' }
Plug 'tpope/vim-projectionist', { 'for': 'clojure' }
Plug 'tpope/vim-dispatch', { 'for': 'clojure' }
" Plug 'kien/rainbow_parentheses.vim'

" Haskell
" Plug 'dag/vim2hs'
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'

" Python
Plug 'jmcantrell/vim-virtualenv'
Plug 'klen/python-mode'
Plug 'saltstack/salt-vim'

" Javascript
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'

" Ruby
Plug 'tpope/vim-rvm'
Plug 'vim-ruby/vim-ruby'

" Rust
Plug 'rust-lang/rust.vim'

" SASS
Plug 'cakebaker/scss-syntax.vim'

" Swift
Plug 'toyamarinyon/vim-swift'

" Nim
Plug 'zah/nim.vim'

" Zig
Plug 'ziglang/zig.vim'

call plug#end()

" call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })

filetype plugin indent on
set regexpengine=1 " for ruby
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

" tagbar
nmap <leader>S :TagbarToggle<cr>

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

"inoremap <silent><expr><tab> CleverTab()
"inoremap <silent><expr><s-tab> CleverUnshiftTab()
noremap <silent> td :tabclose<cr>

" disable highlighting when hitting the return or esc key
"inoremap <silent><script><expr> <CR> CleverReturn()
inoremap <silent> <C-q> <Plug>(copilot-dismiss)
noremap <silent> <CR> :nohlsearch<cr><cr>
noremap <leader>q :call ToggleCopilot()<CR>

function! ToggleCopilot()
    if g:copilot_enabled == 1
        :Copilot disable
        echo "Disabled copilot"
    else
        :Copilot enable
        echo "Enabled copilot"
    endif
endfunction

" Duplicate current line
noremap Y <esc>yyp

let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
nmap <silent> \ :Lexplore<cr>
nmap <silent> \| :Rexplore<cr>
" NERDTree toggle
" noremap \ :NERDTreeToggle<CR>

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
let &t_Co=256
colorscheme hybrid
set background=dark

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
map <leader>r :call RenameFile()<cr>
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

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

"""""""""""""""""
" Running Tests "
"""""""""""""""""
function! RunIfMatchesFileOrVipe(command, file_ext_regex, append_file_as_arg)
    let in_runnable_file = match(expand("%"), a:file_ext_regex) != -1
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
    let in_runnable_file = match(expand("%"), a:file_ext_regex) != -1
    if in_runnable_file
        let t:last_ran_file=@%
    elseif !exists("t:last_ran_file")
        return 0
    elseif match(expand("%"), a:file_ext_regex) == -1
        return 0
    end

    :silent w
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
        let has_ran = RunIfMatchesFile("py.test ", '.*test.*.py$', 1)
    elseif !has_ran && executable('nosetests') == 1
        let has_ran = RunIfMatchesFile("nosetests ", '.*test.*.py$', 1)
    endif

    if !has_ran && executable("go") == 1
        let has_ran = RunIfMatchesFile(':GoTestFunc', '.*test\.go$', 0)
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
    autocmd FileType yaml setlocal expandtab
    autocmd FileType yaml setlocal tabstop=2
    autocmd FileType yaml setlocal softtabstop=2
    autocmd FileType yaml setlocal shiftwidth=2
    autocmd FileType yaml setlocal expandtab

    autocmd FileType sls setlocal tabstop=4
    autocmd FileType sls setlocal softtabstop=4
    autocmd FileType sls setlocal shiftwidth=4
    autocmd FileType sls setlocal expandtab

    " golang
    autocmd FileType go setlocal tabstop=4
    autocmd FileType go setlocal softtabstop=4
    autocmd FileType go setlocal shiftwidth=4

    " autocmd FileType go setlocal efm=%E%.%#FAIL:\ %m,%C%.%#:[0-9]%#:\ %m,%C%.%#\ %f:%l,%Z%.%#stacktrace:\ %#%f:%l,%-G%.%#,#E%f:%l:\ %m
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

    autocmd FileType clojure set lisp

    " make requires tabs
    autocmd FileType make setlocal noexpandtab
    autocmd FileType make setlocal nosmartindent

    autocmd FileType php setlocal noexpandtab
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""
"              PLUGIN CONFIG                  "
"""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""
"      COC     "
""""""""""""""""
" autocmd CursorHold * silent call CocActionAsync('highlight')
" 
" let g:coc_global_extensions = [ 'coc-json', 'coc-go', ]
" 
" set updatetime=400
" nmap <silent> K :call ShowDocumentation()<CR>
" nmap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<CR>
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)
" 
" if has('nvim')
"     inoremap <silent><expr> <c-space> coc#refresh()
" else
"     inoremap <silent><expr> <c-@> coc#refresh()
" endif
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
" nmap <silent> <leader>r <Plug>(coc-rename)
" nmap <silent><nowait> <leader>o :<C-u>CocList outline<CR>
" nmap <silent><nowait> <leader>c :<C-u>CocList commands<CR>
" " Highlight the symbol and its references when holding the cursor
" autocmd CursorHold * silent call CocActionAsync('highlight')
" 
" " Applying code actions to the selected code block
" " Example: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)
" 
" " Remap keys for applying code actions at the cursor position
" nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" " Remap keys for apply code actions affect whole buffer
" nmap <leader>as  <Plug>(coc-codeaction-source)
" " Apply the most preferred quickfix action to fix diagnostic on the current line
" nmap <leader>qf  <Plug>(coc-fix-current)
" 
" nmap <leader>cl  <Plug>(coc-codelens-action)
" 
" " Add `:Format` command to format current buffer
" command! -nargs=0 Format :call CocActionAsync('format')
" 
" " Add `:Fold` command to fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" 
" " Add `:OR` command for organize imports of the current buffer
" command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
" 
" " Use `[g` and `]g` to navigate diagnostics
" " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)
" 
" " File Explorer
" noremap <silent> \ <Cmd>CocCommand explorer<CR>
" 
" autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" 
" function! FormatOnSave()
"     call <SID>StripTrailingWhitespaces()
"     " call CocAction('runCommand', 'editor.action.organizeImport')
"     call CocAction('format')
" endfunction

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


"""""""""""""
" Google Go "
"""""""""""""

augroup googlego_customizations
    autocmd!
    autocmd Filetype go nmap <Leader>p :Format
    " autocmd BufWritePre *.go call FormatOnSave()
    " autocmd FileType go nmap <Leader>i <Plug>(go-implements)
    " autocmd FileType go nmap <Leader>r <Plug>(go-rename)

"     autocmd FileType go nmap <Leader>i <Plug>(go-implements)
"     autocmd FileType go nmap <Leader>r <Plug>(go-rename)
"     " sort isn't working for gotags
"     autocmd FileType go nmap <Leader>c :!gotags -f tags -sort=0 -R $GOPATH .<cr>
augroup END
let g:go_fmt_command = "goimports"
let g:go_rename_command = 'gopls'
" rely on vim-lsp ?
" let g:go_fmt_autosave = 0
" let g:go_gopls_enabled = 0
" let g:go_code_completion_enabled = 0
" let g:go_auto_sameids = 0
" let g:go_fmt_autosave = 0
" let g:go_def_mapping_enabled = 0
" let g:go_diagnostics_enabled = 0
" let g:go_echo_go_info = 0
" let g:go_metalinter_enabled = 0
" let g:go_doc_popup_window = 0

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

"""""""""""
" Haskell "
"""""""""""
" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
augroup haskell_customizations
    autocmd!
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
    autocmd FileType haskell nmap <Leader>c :GhcModCheck<cr>
    autocmd FileType haskell nmap <Leader>l :GhcModLint<cr>
    autocmd FileType haskell nmap <Leader>e :GhcModType<cr>
    autocmd FileType haskell nmap <Leader>i :GhcModTypeInsert<cr>
    " autocmd FileType haskell nmap <Leader>g :GhcModSigCodegen<cr>
    autocmd FileType haskell nmap <Leader>C :GhcModCheckClear<cr>
    " autocmd FileType haskell nnoremap <CR> :silent! GhcModTypeClear<cr>:nohlsearch<cr><cr>
augroup END

""""""""
"  FZF "
""""""""
nmap <Leader>f :FZF<cr>
nmap <leader>Fp :GFiles<cr>
nmap <leader>Fg :GFiles?<cr>
nmap <leader>b :Buffers<cr>
nmap <leader>m :Marks<cr>
nmap <leader>g :Rg<space>
nmap <leader>G :RG<space>
" nmap <leader>

""""""""""""""""""
" vim-easy-align "
""""""""""""""""""
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

""""""""""""""""
" vim-markdown "
""""""""""""""""
let g:vim_markdown_initial_foldlevel=99

""""""""""""
" vim-json "
""""""""""""

let g:vim_json_syntax_conceal = 0

"""""""""


lua <<EOF
    local lsp_zero = require('lsp-zero')

    lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
    end)

    require('mason').setup({})
    require('mason-lspconfig').setup({
        ensure_installed = {
            'cssmodules_ls',
            'dockerls',
            'gopls',
            'html',
            'htmx',
            'jsonls',
            'tsserver',
        },
        handlers = {
            lsp_zero.default_setup,
        },
    })
EOF
