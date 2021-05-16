{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    macvim
    htop
    jq
    apacheKafka
    zookeeper
    kubectl
    go
    nodejs
    kubernetes-helm
    terraform_0_13
    terraform-providers.digitalocean
    terraform-providers.random
    terraform-providers.template
    terraform-providers.local
    terraform-providers.random
    terraform-providers.vault
    gnupg
    pinentry_mac
    python39
    python39Packages.virtualenv
    # TODO: install virtualfish
    ag
    doctl
    tmux
  ];

  users.nix.configureBuildUsers = true;

  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 30;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;

  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "bottom";
  # system.defaults.dock.showhidden = true;
  # system.defaults.dock.mru-spaces = false;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  nix.gc.user = "jeff";
  nix.gc.automatic = true;

  home-manager = {
    useUserPackages = true;
    users.jeff = { pkgs, ...}: {
      programs.git = {
        enable = true;
        userName = "Jeff Hui";
        userEmail = "jeff@jeffhui.net";
        signing = {
          key = "A1B917EB55BC65057454359C297276AC3F8D4441";
        };
        aliases = {
          "st" = "status";
        };
        extraConfig = {
          url."git@github.com:".insteadOf = "https://github.com/";
        };
      };

      programs.emacs.enable = true;
      programs.neovim.enable = true;
      programs.go = {
        enable = true;
        goPrivate = [ "github.com/jeffh/*" ];
      };

      programs.vim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [
          vim-hybrid
          coc-nvim
          coc-css
          coc-html
          coc-go
          coc-json
          repeat
          vim-commentary
          ctrlp-vim
          ctrlp-py-matcher
          surround
          nerdtree
          vim-unimpaired
          vim-fugitive
          vim-gitgutter
          vim-abolish
          tagbar
          # TODO: luan/vipe

          vim-markdown
          vim-nix
          elm-vim
          vim-terraform
          vim-terraform-completion
          vim-go
          # BEGIN CLOJURE
          vim-sexp
          vim-clojure-highlight
          vim-clojure-static
          vim-fireplace
          vim-salve
          vim-dispatch
          # END CLOJURE
          # vim-virtualenv
          python-mode

          vim-javascript
          vim-json

          # vim-rvm
          vim-ruby
          rust-vim
          # TODO: vim-swift
          nim-vim
          zig-vim
        ];

        # TODO: use extraConfig = (builtins.readFile ./vimrc); to load this config
        extraConfig = ''
" Don't emulate vi bugs
set nocompatible
set shell=/bin/bash

filetype plugin indent on
set regexpengine=1 " for ruby
syntax enable

"""""""""""""""""""""""""""""""""""""""""""""""
"               KEY BINDINGS                  "
"""""""""""""""""""""""""""""""""""""""""""""""

" Special key for custom bindings
let mapleader = ","
let g:mapleader = ","

" fast editing of vimrc file
" ,v => edits current file
map <leader>v :e ~/.vimrc<CR>

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

" disable highlighting when hitting the return or esc key
nnoremap <CR> :nohlsearch<cr><cr>

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
    endif
    let line_to_cursor = strpart( getline('.'), 0, col('.')-1 )
    if strlen( line_to_cursor ) == 0
        return "\<Tab>"
    elseif line_to_cursor =~ '\s\s*$'
        return "\<Tab>"
    elseif line_to_cursor =~ '/$'
        return "\<C-X>\<C-F>"
    elseif exists('&omnifunc') && &omnifunc != ${"''"}
        return "\<C-X>\<C-O>"
    else
        return "\<C-N>"
    endif
endfunction

imap <expr><tab> CleverTab()
inoremap <s-tab> <C-p>

" Duplicate current line
noremap Y <esc>yyp

" NERDTree toggle
noremap \ :NERDTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""
"                CORE CONFIG                  "
"""""""""""""""""""""""""""""""""""""""""""""""

if $TMUX == ${"''"}
    set clipboard=unnamed  " System-like clipboard behavior if not in TMUX
endif

set tags=tags,$HOME/tags " Search path for ctags

set notimeout          " Don't wait for timeout between command combinations

set nowrap             " no line wrapping
set textwidth=0        " width of document
set formatoptions-=t   " don't automatically wrap text when typing

set switchbuf="usetab" " buffer switching behavior - use tab or window if available

set showmatch          " show paren matching

set scrolloff=3        " Keep more context when scrolling off the end of a buffer
set so=7               " move 7 lines when moving vertical
set magic              " Set for regular expressions' backslashes

" visualize invisible characters. Show spaces at the end of lines and tabs.
set list
set listchars=tab:\|\ ,trail:·

set foldmethod=syntax  " code folding is determined by syntax
set foldlevel=99  " default fold level


""""""""""
" Search "
""""""""""

set hlsearch   " highlight search results
set incsearch  " incremental search
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
set wildmenu
set path+=**

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
set complete=.,w,b,d,i,t

" menu => Show menu when multiple autocomplete items are available
" preview => Show extra info about the currently selected completion in menu
" menuone => Shows menu when only one item is available for autocomplete
" longest => Only inserts longest common text for matches
set completeopt=menu,preview

set noinfercase  " autocomplete without being case sensitive

""""""""""""""""""""""""
" Files, Backups, Undo "
""""""""""""""""""""""""

set ffs=unix,dos,mac " default line endings

set history=600      " command line history
set undolevels=9000  " undo history

" auto reload vimrc when edited
augroup vim_autoreload
    autocmd!
    autocmd bufwritepost .vimrc source ~/.vimrc
augroup END

" vim's backup / swap system
set backupdir=~/.vim/tmp/,~/.tmp,/var/tmp,/tmp
set directory=~/.vim/tmp/,~/.tmp,/var/tmp,/tmp
" disable all swap, backup and writebackups
set nobackup     " no backups
set writebackup  " except when writing files
set noswapfile   " no swapfiles

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

set autoread                   " auto refresh files that were changed
set virtualedit=all            " let cursor stray beyond textfile bounds
set backspace=eol,indent,start " backspace behaves like normal programs

" Auto save buffers when focus is lost
au FocusLost * silent! :wa
" Auto save when switching buffers
set autowrite
" remember marks & undos for background buffers
set hidden

" set number " enable line numbers
"set numberwidth=5

" Set encoding and language
set encoding=utf8
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

" Always show status bar
set laststatus=2

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
set shortmess=aOstT " shortens messages to avoid 'press a key' prompt
set ttyfast

" show matching parens, brackets and braces
set showmatch
set matchtime=1

" Display cursor location info in the bottom right of status bar
set ruler

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
set norelativenumber

"""""""""
" Theme "
"""""""""
let &t_Co=256
set background=dark
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
    if new_name != ${"''"} && new_name != old_name
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
    call inputrestore()
    exec ':silent !rm ' . file_name
    exec ':silent bw'
    redraw!
    exec ":echom \"Deleted " . file_name . "\""
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
nmap <leader>g :call FindSymbol()<cr>

" Build tags
map <leader>c !ctags -R .

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

""""""""""""
" Defaults "
""""""""""""
set expandtab          " use spaces for tab key
set autoindent         " automatically detect how to indent
set smarttab           " be smart to how much to indent
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
    autocmd Filetype go nmap <Leader>p :Fmt
    autocmd FileType go nmap <Leader>i <Plug>(go-implements)
    autocmd FileType go nmap <Leader>r <Plug>(go-rename)
augroup END
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 0
let g:go_rename_command = 'gopls'

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
    autocmd FileType haskell nmap <Leader>g :GhcModSigCodegen<cr>
    autocmd FileType haskell nmap <Leader>C :GhcModCheckClear<cr>
    autocmd FileType haskell nnoremap <CR> :silent! GhcModTypeClear<cr>:nohlsearch<cr><cr>
augroup END

"""""""""
" CtrlP "
"""""""""
let g:ctrlp_map = '<leader>f'
let g:ctrlp_cmd = 'CtrlP' " 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'ra'
" let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_lazy_update = 75
let g:ctrlp_max_files = 0
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\'
if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor
    let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
                \ --ignore .git
                \ --ignore .svn
                \ --ignore .hg
                \ --ignore .DS_Store
                \ --ignore "**/*.pyc"
                \ -g ""'
endif

nmap <Leader>s :CtrlPTag<cr>

"""""""""""""""
" neocomplete "
"""""""""""""""
" inoremap <expr><C-g> neocomplete#cancel_popup()
"
" let g:neocomplete#enable_at_startup = 1
" let g:neocomplete#enable_smart_case = 1
" let g:neocomplete#sources#syntax#min_keyword_length = 3
" let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" let g:neocomplete#force_overwrite_completefunc = 1
"
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"
" if !exists('g:neocomplete#sources#omni#input_patterns')
"   let g:neocomplete#sources#omni#input_patterns = {}
" endif
" let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
" let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
" let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

""""""""""""""""""
" vim-easy-align "
""""""""""""""""""
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

""""""""""""""""
" vim-markdown "
""""""""""""""""
let g:vim_markdown_initial_foldlevel=99

""""""""""
" vim-go "
""""""""""
augroup vim_go
    autocmd!
    autocmd FileType go nmap <Leader>i <Plug>(go-implements)
    autocmd FileType go nmap <Leader>r <Plug>(go-rename)
    " sort isn't working for gotags
    autocmd FileType go nmap <Leader>c :!gotags -f tags -sort=0 -R $GOPATH .<cr>
augroup END

" let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1

""""""""""""
" vim-json "
""""""""""""

let g:vim_json_syntax_conceal = 0
          '';
      };

      programs.gpg = {
        enable = true;
        settings = {
          # pinentry-program = "/usr/local/bin/pinentry-mac";
          enable-ssh-support = true;
          write-env-file = true;
          use-standard-socket = true;
          default-cache-ttl = "600";
          max-cache-ttl = "7200";
        };
      };

      home.file.".tmux.conf".text = ''
# Set colors
unbind C-b
set -g prefix 'C-\'

bind-key k clear-history

set-option -g default-terminal "screen-256color"
set-option -g mouse on
setw -g window-status-current-style fg=white,bg=black

# Count sessions start at 1
set -g base-index 1
set -s escape-time 0

bind c new-window -c "#{pane_current_path}"
bind % split-window -v -c "#{pane_current_path}"
bind '"' split-window -h -c "#{pane_current_path}"

bind r source-file ~/.tmux.conf

unbind-key j
bind-key j select-pane -D

unbind-key k
bind-key k select-pane -U

unbind-key h
bind-key h select-pane -L

unbind-key l
bind-key l select-pane -R

bind-key -n M-k clear-history
        '';
    };
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;  # default shell on catalina
  programs.fish = {
    enable = true;
    shellInit = ''
set -x PATH /usr/local/bin /usr/local/sbin $PATH
test -d $HOME/.local/bin; and set -x PATH $HOME/.local/bin $PATH
test -d $HOME/bin; and set -x PATH $HOME/bin $PATH

if test -e which
    setenv EDITOR (which vim)
end
setenv ALTERNATIVE_EDITOR ""
      '';

    loginShellInit = ''
begin # SSH Agent
    if test -z "$SSH_ENV"
        set -xg SSH_ENV $HOME/.ssh/environment
    end
    if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
        source $SSH_ENV > /dev/null
    end
    if not test -z "$SSH_AGENT_PID"
        ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent

        if test $status -ne 0
            ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
            chmod 600 "$SSH_ENV"
            source "$SSH_ENV" > /dev/null
        end
    end
end

# needed for gpg-agent
# setenv GPG_TTY (tty)
# gpg-agent --daemon >/dev/null 2>&1

#set -e SSH_AUTH_SOCK
#set -U -x SSH_AUTH_SOCK ~/.gnupg/S.gpg-agent.ssh

#ssh-add -K 2> /dev/null

if type -q python3
    eval (python3 -m virtualfish 2>/dev/null)
end

# golang 
test -d ~/go/bin; and set -x PATH ~/go/bin $PATH
test -d /usr/local/go/bin; and set -x PATH /usr/local/go/bin $PATH
test -d /usr/local/opt/go/libexec/bin; and set -x PATH /usr/local/opt/go/libexec/bin $PATH

# rust
test -d $HOME/.cargo/bin; and set -x PATH $HOME/.cargo/bin $PATH

# capstan
test -d /usr/local/bin/qeum-system-x86_64; and set CAPSTAN_QEMU_PATH /usr/local/bin/qemu-system-x86_64

# ruby
if test -d $HOME/.rbenv/bin
    set -x PATH $HOME/.rbenv/bin $PATH
end
if test -d $HOME/.rbenv/shims
    set -x PATH ~/.rbenv/shims $PATH
    set -x RBENV_SHELL fish
#set -gx RBENV_ROOT /usr/local/var/rbenv
    if test -e which
        which rbenv > /dev/null
        if test $status -eq 0
            rbenv init - | source
        end
    end
end

# swift
if type -q swiftenv
    set -x SWIFTENV_ROOT "$HOME/.swiftenv"
    if test -d "$SWIFTENV_ROOT/bin"
        set -x PATH "$SWIFTENV_ROOT/bin" $PATH
        status --is-interactive; and swiftenv init - | source
    end
end

# graalvm
if test -d "/usr/local/opt/graalvm/1.0.0-rc12/Contents/Home/"
    set -x GRAALVM_HOME "/usr/local/opt/graalvm/1.0.0-rc12/Contents/Home/"
end
if test -d "/opt/graalvm/1.0.0-rc12/Contents/Home/"
    set -x GRAALVM_HOME "/opt/graalvm/1.0.0-rc12/Contents/Home/"
end

# iterm2
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

if test -d "/nix"
    eval (~/.config/fish/nix.sh)
    set -x NIX_SSL_CERT_FILE /etc/ssl/cert.pem
end

if test -d "/run/current-system/sw/bin"
    for p in /run/current-system/sw/bin ~/bin
        if not contains $p $fish_user_paths
            set -g fish_user_paths $p $fish_user_paths
        end
    end
    set -x NIX_PATH "darwin-config=$HOME/.nixpkgs/darwin-configuration.nix" $NIX_PATH
    set -x NIX_USER_PROFILE_DIR "/nix/var/nix/profiles/per-user/$USER"
    set -x NIX_PROFILES "/nix/var/nix/profiles/default /run/current-system/sw $HOME/.nix-profile"
end
      '';

      promptInit = ''
# Display the following bits on the left:
# * Virtualenv name (if applicable, see https://github.com/adambrenecki/virtualfish)
# * Current directory name
# * Git branch and dirty state (if inside a git repo)

function _git_branch_name
  if type -q git
    echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
  end
end

function _is_git_dirty
  if type -q git
    echo (git status -s --ignore-submodules=dirty ^/dev/null)
  end
end

function fish_prompt
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  set -l cwd $cyan(basename (prompt_pwd))

  # output the prompt, left to right

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
      echo -n -s (set_color -o blue) 'virtualenv: ' (basename "$VIRTUAL_ENV") $normal ' '
  end

  # Add a newline
  echo -e ""

  # Display [nix] if in a nix shell
  if test -n "$IN_NIX_SHELL"
     echo -n -s (set_color -o green) 'nix: ' $normal
  end

  # Display the current directory name
  echo -n -s $cwd $normal

  # Show git branch and dirty state
  if [ (_git_branch_name) ]
    set -l git_branch '(' (_git_branch_name) ')'

    if [ (_is_git_dirty) ]
      set git_info $red $git_branch " ★ "
    else
      set git_info $green $git_branch
    end
    echo -n -s ' · ' $git_info $normal
  end

  # Terminate with a nice prompt char
  echo -n -s ' ⟩ ' $normal

end

# Display the compressed current working path on the right
# If the previous command returned any kind of error code, display that too
 
function fish_right_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l red (set_color -o red)
  set -l normal (set_color normal)
 
  echo -n -s $cyan (prompt_pwd)
 
  if test $last_status -ne 0
    set_color red
    printf ' %d' $last_status
    set_color normal
  end
end
      '';
  };

  services.nix-daemon.enable = false;
  nix.useDaemon = false;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

