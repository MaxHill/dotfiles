"-----------------------------PLUGINS-----------------------------"
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'wincent/terminus'
Plug 'christoomey/vim-tmux-navigator'

" Colors
Plug 'dracula/vim', { 'as': 'dracula' }

" Global editing
Plug 'tpope/vim-surround'
Plug 'editorconfig/editorconfig-vim'


call plug#end() " All of your Plugins must be added before the following line
filetype plugin indent on    " Required by vundle

"-----------------------------GENERAL SETTINGS-----------------------------"
set nocompatible   " Disable vi-compatibility
filetype off      " required
filetype plugin on
syntax on
"set t_Co=256
set background=dark

let g:dracula_italic = 0
colorscheme dracula
highlight Normal ctermbg=None
let g:airline_theme='dracula'

"-----------------------------VIM SETTINGS-----------------------------"
let mapleader=","                       " Set , as the leader key
set hlsearch
set incsearch
set guifont=Fira\ Code:h15
set guioptions-=T                       " Removes top toolbar
set guioptions-=r                       " Removes right hand scroll bar
set go-=L                               " Removes left hand scroll bar
set linespace=17
set showmode                            " always show what mode we're currently editing in
set nowrap                              " don't wrap lines
set tabstop=2                           " a tab is four spaces
set smarttab
set tags=tags
set softtabstop=2                       " when hitting <BS>, pretend like a tab is removed, even if spaces
set expandtab                           " expand tabs by default (overloadable per file type later)
set shiftwidth=2                        " number of spaces to use for autoindenting
set shiftround                          " use multiple of shiftwidth when indenting with '<' and '>'
set backspace=indent,eol,start          " allow backspacing over everything in insert mode
set autoindent                          " always set autoindenting on
set copyindent                          " copy the previous indentation on autoindenting
set number                              " always show line numbers
set ignorecase                          " ignore case when searching
set smartcase                           " ignore case if search pattern is all lowercase,
set timeout timeoutlen=200 ttimeoutlen=100
set visualbell                          " don't beep
set noerrorbells                        " don't beep
set autowrite                           " Save on buffer switch
set mouse=a
set laststatus=2
set cursorline
set colorcolumn=81                      " Highlight to column to see 80 char mark
set complete+=kspell                    " Autocomplete with dictionary words when spell check is on
set list listchars=tab:»·,trail:·,nbsp:·
set directory=$HOME/.vim/swapfiles//    " Keep swap files out of current directory

" let &colorcolumn=join(range(81,999),",")      " Highlight everything after 80 chars
" let &colorcolumn=join(range(81,81),",")      " Highlight the 80 chars mark
highlight ColorColumn ctermbg=246 guibg=#2c2d27 " Set the color of the 80 char mark

"-----------------------------MAPPINGS-----------------------------"
" Add simple highlight removal. [,space]
nmap <Leader><space> :nohlsearch<cr>
" Sort selected alphabeticaly
noremap <Leader>s :sort<cr>
map <C-n> :NERDTreeToggle<CR>
map <D-r> :CtrlPBufTag<CR>
nmap <D-p> :CtrlP<cr>
map ,ev :tabedit ~/.vimrc
map ,t :T

"Dissable arrows
nnoremap <up>    <nop>
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>

" Navigate splits with ctrl + hjkl
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

nnoremap <silent> <C-S> :<C-u>Update<CR>
"-------------Auto-Commands--------------"
"Automatically source the Vimrc file on save.
augroup autosourcing
    autocmd!
    autocmd BufWritePost .vimrc source %
augroup END

" Spellcheck based on file
au BufNewFile,BufRead gitcommit set spell
au BufNewFile,BufRead COMMIT_EDITMSG set spell
au BufNewFile,BufRead *.md set spell

" Auto wrap text
au FileType gitcommit set tw=62
au BufRead,BufNewFile gitcommit setlocal textwidth=62
au BufRead,BufNewFile *.md setlocal textwidth=80

"-----------------------------Commands-----------------------------"
command! -nargs=1 Gv execute "!npm run generate:view" string(<q-args>)
command! -nargs=1 Gc execute "!npm run generate:component" string(<q-args>)
command! -nargs=1 Ge execute "!npm run generate:element" string(<q-args>)
command! -nargs=1 Gt execute "!npm run generate:test" string(<q-args>)
command! T execute "!npm --no-color run unit"

"-----------------------------PLUGIN SETTINGS-----------------------------"
" CTRLP
set wildignore+=*/tmp/*,*/node_modules/*,*/cache/*,*.so,*.swp,*.zip
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_mruf_relative = 1
let g:ctrlp_show_hidden = 1

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" NERDTree
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg']
let g:NERDTreeWinPos = "right"
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeRespectWildIgnore=1
let NERDTreeShowHidden=1

" Airline
let g:airline#extensions#tabline#enabled = 0

if has("gui_macvim")
  macmenu &File.Print key=<nop>
  " set transparency=5
endif
