"-----------------------------PLUGINS-----------------------------"
call plug#begin('~/.config/nvim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'mattn/emmet-vim'
Plug 'posva/vim-vue'
Plug 'jdkanani/vim-material-theme'
Plug 'jiangmiao/auto-pairs'
Plug 'leafgarland/typescript-vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'digitaltoad/vim-pug'
Plug 'tpope/vim-surround'
Plug 'wincent/terminus'
Plug 'editorconfig/editorconfig-vim'
Plug 'gcorne/vim-sass-lint'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'mileszs/ack.vim'
Plug 'pangloss/vim-javascript'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Quramy/tsuquyomi'
Plug 'Shougo/vimproc.vim', { 'do': 'make -f make_mac.mak' }
Plug 'neomake/neomake'
Plug 'Quramy/vim-js-pretty-template'
Plug 'rainglow/vim'
Plug 'octref/RootIgnore'
Plug 'jdkanani/vim-material-theme'
Plug 'jackiehluo/vim-material'

call plug#end() " All of your Plugins must be added before the following line
filetype plugin indent on    " Required by vundle

"-----------------------------GENERAL SETTINGS-----------------------------"
set nocompatible   " Disable vi-compatibility
filetype off      " required
filetype plugin indent on
set t_Co=256
syntax on
set background=dark
colorscheme material
"colorscheme material-theme
" colorscheme bold
" hi CursorLine   cterm=NONE ctermbg=8 ctermfg=NONE
" hi CursorLine   cterm=NONE ctermbg=7 ctermfg=NONE

"-----------------------------VIM SETTINGS-----------------------------"
let mapleader=","                       " Set , as the leader key
set hlsearch
set incsearch
set guifont=Fira\ Code:h15
set guioptions-=T                       " Removes top toolbar
set guioptions-=r                       " Removes right hand scroll bar
set go-=L                               " Removes left hand scroll bar
set linespace=20
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
" set copyindent                          " copy the previous indentation on autoindenting
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


" Add python
let g:python2_host_prog = '/usr/local/bin/python'

highlight ColorColumn ctermbg=246 guibg=#2c2d27 " Set the color of the 80 char mark
highlight clear SignColumn

"-----------------------------MAPPINGS-----------------------------"
" Add simple highlight removal. [,space]
nmap <Leader><space> :nohlsearch<cr>
" Sort selected alphabeticaly
noremap <Leader>s :sort<cr>
map <C-n> :NERDTreeToggle<CR>
map <D-r> :CtrlPBufTag<CR>
map ,ev :tabedit ~/.config/nvim/init.vim
map ,i :TsuImport<CR>

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
    autocmd BufWritePost ~/.config/nvim/init.vim source %
augroup END

" Spellcheck based on file
au BufNewFile,BufRead gitcommit set spell
au BufNewFile,BufRead COMMIT_EDITMSG set spell
au BufNewFile,BufRead *.md set spell

" Auto wrap text
au FileType gitcommit set tw=62
au BufRead,BufNewFile gitcommit setlocal textwidth=62
au BufRead,BufNewFile *.md setlocal textwidth=80

" Fix syntax not being set 
autocmd BufNewFile,BufRead *.vue set ft=vue
autocmd BufNewFile,BufRead *.scss set ft=scss

"-----------------------------Commands-----------------------------"
command! -nargs=1 G execute "!yarn ng g" string(<q-args>)

"-----------------------------PLUGIN SETTINGS-----------------------------"
" CTRLP
set wildignore+=*/tmp/*,*/node_modules/*,*/cache/*,*.so,*.swp,*.zip
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_mruf_relative = 1

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

" Airline
let g:airline_theme='sol'
let g:airline#extensions#tabline#enabled = 0

" Neomake
" When writing a buffer.
call neomake#configure#automake('w')
" When writing a buffer, and on normal mode changes (after 750ms).
call neomake#configure#automake('nw', 0)
" When reading a buffer (after 1s), and when writing.
call neomake#configure#automake('rw', 0)

" Shows warning and error counts in vim-airline
let g:airline#extensions#neomake#enabled = 1

" Preseve cursor position when quickfix window is open
let g:neomake_open_list = 2
let g:neomake_typescript_enabled_makers = ['tslint']
" Css Linting
let g:neomake_css_enabled_makers = ['sass-lint']
let g:neomake_sass_enabled_makers = ['sass-lint']
let g:neomake_scss_enabled_makers = ['sass-lint']
" HTML Linting
let g:neomake_html_enabled_makers = ['htmlhint']

" Lint as you type
autocmd InsertChange,TextChanged * update | Neomake

" Typescript
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript

" Tsuquyomi
let g:tsuquyomi_single_quote_import=1

" Emmet
let g:user_emmet_expandabbr_key='<Tab>'
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" Youcompleteme
let g:ycm_filetype_blacklist = { 'html': 1, 'css': 1 }

" Vim-js-pretty-template
autocmd FileType typescript JsPreTmpl html
autocmd FileType typescript syn clear foldBraces

if has("gui_macvim")
  macmenu &File.Print key=<nop>
  " set transparency=5
endif
