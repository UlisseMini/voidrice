"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|

" Plugins {{{
call plug#begin('~/.config/nvim/plugged')
" TODO Figure out how to make deoplete non slow.
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" General
Plug 'tpope/vim-surround'
Plug 'Shougo/neosnippet.vim'
Plug 'UlisseMini/neosnippet-snippets'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'vim-syntastic/syntastic'
Plug 'sheerun/vim-polyglot'

" Support for LSP Client / Server
"Plug 'autozimu/LanguageClient-neovim', {
"      \ 'branch': 'next',
"      \ 'do': './install.sh'
"      \ }

" Golang development (settings in ftplugin/go.vim)
Plug 'fatih/vim-go',      { 'for': 'go' }
Plug 'sebdah/vim-delve',  { 'for': 'go' }
Plug 'buoto/gotests-vim', { 'for': 'go' }
Plug 'zchee/deoplete-go', { 'for': 'go', 'do': 'make' }

" Elixir
Plug 'mhinz/vim-mix-format',      { 'for': 'elixir'}
Plug 'elixir-editors/vim-elixir', { 'for': 'elixir'}
Plug 'slashmili/alchemist.vim',   { 'for': 'elixir'}

" Other languages
Plug 'rhysd/vim-crystal',    { 'for': 'crystal' }
Plug 'leafo/moonscript-vim', { 'for': 'moon' }
Plug 'UlisseMini/vim-pp' " Memes
Plug 'rust-lang/rust.vim',  { 'for': 'rust' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
"Plug 'ElmCast/elm-vim',    { 'for': 'elm' }

" Is markdown a language?
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_fenced_languages = ['go=go', 'hs=haskell', 'lua=lua', 'py=python', 'python=python', 'viml=vim', 'bash=sh', 'ini=dosini']

" Tiny plugins
Plug 'gcmt/taboo.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'christoomey/vim-tmux-navigator'
Plug 'PotatoesMaster/i3-vim-syntax', { 'for': 'i3' }

" ColorSchemes

Plug 'romainl/flattened'
Plug 'morhetz/gruvbox'
call plug#end()

" syntastic{{{
let g:syntastic_go_checkers = ['gofmt', "go"]
let g:syntastic_crystal_checkers = ['crystal']

let g:syntastic_elixir_checkers = ['elixir']
let g:syntastic_enable_elixir_checker = 1

let g:syntastic_loc_list_height=3

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1

" When set to 2 the error window will be automatically closed when no errors are
" detected, but not opened automatically. >
let g:syntastic_auto_loc_list            = 2

let g:syntastic_check_on_wq              = 0
"}}}

" LanguageClient {{{
let g:LanguageClient_settingsPath=expand("~/.config/nvim/languageClient.json")
command! Fmt call LanguageClient#textDocument_formatting()
"}}}

" rust{{{
let g:rustfmt_autosave = 0
"}}}

" Make deoplete load on startup
let g:deoplete#enable_at_startup = 1
set pumheight=10 " Completion window max size

" change the deoplete delay before autocomplete
let g:deoplete#auto_complete_delay = 0

" Make neosnippet use tabs for expanding snippets
imap <expr><TAB>
      \ neosnippet#expandable_or_jumpable() ?
      \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

"}}}

" Basics{{{
filetype plugin indent on
syntax enable
set encoding=utf-8
set ruler showmode noshowcmd
set autoread                 " read changes outside of vim automatically
set noerrorbells             " begone beeps
set autowrite                " Automatically save before :next, :make etc.
set hidden                   " Non retarded buffers
set history=1000             " vim ex mode history
set fileformats=unix,dos,mac " Prefer Unix over Windows over OS 9 formats
set copyindent               " copy existing indentation
set nohlsearch               " Don't highlight all search matches.
set linebreak
set number relativenumber

" colors
if has("termguicolors")
  set termguicolors
endif

" i don't like fill characters!
set fillchars =fold:\ ,stl:\ ,stlnc:\ 

" Undo settings
set undofile undodir=~/.config/nvim/undo
set undolevels=1000

" disable autocompletion preview
set completeopt-=preview

set numberwidth=1 " Use the least amount of space possible

" Map leader, set to space
nnoremap <Space> <nop>
let mapleader = " "

" tab settings
set tabstop=4
set shiftwidth=4

" use spaecs instead of tabs
set expandtab

" disable status bar
set laststatus=0

" Better pattern matching
set ignorecase
set smartcase

" folding
set foldmethod=manual

" Splits open at the bottom and right
set splitbelow splitright

" Better ex mode completion
set wildmenu

" Tweaks for file browsing
let g:netrw_banner=0     " disable anoying banner
let g:netrw_liststyle=3  " tree view
let g:netrw_winsize = 25 " window size
"}}}

" General leader bindings more in ./ftplugin/*.vim{{{
nn <leader>s :%s//g<left><left>
nn <leader>g :%g/
nn <leader>l :noh<cr>

nn <leader>f :FZF<cr>
nn <leader>= mzgg=G`z

" execute vimscript under cursor (register ")
nn <leader>g Y:@"<cr>
vn <leader>g y:@"<cr>

" show syntastic errors
nn <leader>e :Errors<cr>
nn <leader>c :SyntasticCheck<cr>

" buffer navigation
nn <leader>n :bn<cr>
nn <leader>p :bp<cr>

" open a terminal in a new tab, i use tmux so i don't use this
" nn <C-t> :tabnew<cr>:te<cr>:<bs>i

" Commands
command Hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>

command Nm set number! relativenumber!
command Ctags !ctags -R .
command Rc FZF ~/.config/nvim

" useful for view the full output of :highlight
func TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endf

" toggle iferr block folding
func ToggleIfErr()
  if !exists("b:IfErr") || !b:IfErr
    " set status
    let b:IfErr = 1

    " fold all iferr blocks
    %g/if .*err != nil.*{\_.\{-\}}/.,/}/fo

    " go to where we where before the regex
    execute "normal \<C-o>"
  else
    " set status
    let b:IfErr = 0

    " unfold all
    normal zR
  endif
endfu
nn <leader>gf :call ToggleIfErr()<cr>:<bs>
"}}}



" AutoCmd{{{
" for some reason asm.vim in ./ftplugin was not working
au Filetype asm set syntax=nasm

func ColorScheme()
  " use my terminals background colors not the colorschemes
  " hi! Normal       ctermbg=NONE guibg=NONE
  hi! LineNr       ctermbg=NONE guibg=NONE
  hi! TabLine      ctermbg=NONE guibg=NONE
  hi! TabLineFill  ctermbg=NONE guibg=NONE
  hi! VertSplit    ctermbg=NONE guibg=NONE
  hi! StatusLine   cterm=NONE   gui=NONE
  hi! Folded       ctermbg=NONE guibg=NONE

  " Link some things
  hi! link StatusLineNC StatusLine
  hi! link vimfunction Function
endf
au ColorScheme * call ColorScheme()

" Disable line numbers in the terminal
au TermOpen * setlocal nonumber norelativenumber noruler noshowmode
" showmode is a global option, so on terminal close we need to reset it
au TermClose * setlocal showmode

" Disable auto commenting
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Hide QFix buffer (quickfix)
augroup QFix
  autocmd!
  autocmd FileType qf setlocal nobuflisted
augroup END
"}}}

" Remaps{{{
" better marks
nn ' `
nn ` '

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

tnoremap <C-w><C-h> <C-\><C-n><C-w>h
tnoremap <C-w><C-j> <C-\><C-n><C-w>j
tnoremap <C-w><C-k> <C-\><C-n><C-w>k
tnoremap <C-w><C-l> <C-\><C-n><C-w>l

" exit terminal mode with control e
tnoremap <C-e> <C-\><C-n>

" Bindings to make copying and pasting easier
vnoremap <C-c> "+y

" Center the screen when searching
nnoremap n nzz

" make Y non retarded
nnoremap Y y$

" say selected text with espeak
vno pp :w !espeak &>/dev/null <cr>

" save file with CTRL-S
nno  :w<cr>
ino  :w<cr>
"}}}

" Colorscheme{{{
set background=dark
let g:gruvbox_italicize_comments = 1
let g:gruvbox_italic             = 1

" colo flattened_dark
colo gruvbox
hi! Operator gui=bold cterm=bold
"}}}

" Copy selected text to system clipboard using xclip{{{
let g:clipboard = {
      \   'name': 'xclip',
      \   'copy': {
      \      '+': 'xclip -i -selection clipboard',
      \      '*': 'xclip -i -selection clipboard',
      \    },
      \   'paste': {
      \      '+': 'xclip -o -selection clipboard',
      \      '*': 'xclip -o -selection clipboard',
      \   },
      \   'cache_enabled': 1,
      \ }
"}}}
