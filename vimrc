"-----------------------------PLUGINS-----------------------------"
if has("win32")
    set rtp+=%HOME%/vimfiles/bundle/Vundle.vim
    call vundle#begin('%USERPROFILE%/vimfiles/bundle')
else
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
endif

Plugin 'VundleVim/Vundle.vim' " let Vundle manage Vundle, required
Plugin 'scrooloose/syntastic'
Plugin 'mattn/emmet-vim'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'stephpy/vim-php-cs-fixer'
Plugin 'msanders/snipmate.vim'
Plugin 'StanAngeloff/php.vim'
Plugin 'arnaud-lb/vim-php-namespace'
Plugin 'posva/vim-vue'
Plugin 'jdkanani/vim-material-theme'
Plugin 'OrangeT/vim-csharp'
Plugin 'Townk/vim-autoclose'
Plugin 'leafgarland/typescript-vim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'adamclerk/vim-razor'
Plugin 'digitaltoad/vim-pug'
Plugin 'rakr/vim-one'
Plugin 'tpope/vim-surround'
Plugin 'wincent/terminus'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'gcorne/vim-sass-lint'
Plugin 'dkprice/vim-easygrep'
Plugin 'Valloric/YouCompleteMe'
Plugin 'prettier/vim-prettier'
Plugin 'ternjs/tern_for_vim'

call vundle#end() " All of your Plugins must be added before the following line
filetype plugin indent on    " Required by vundle

"-----------------------------GENERAL SETTINGS-----------------------------"
set nocompatible   " Disable vi-compatibility
filetype off      " required
filetype plugin on
syntax on
set background=dark
colorscheme wildcherry

"-----------------------------VIM SETTINGS-----------------------------"
let mapleader=","                       " Set , as the leader key
autocmd BufWritePre *.php :%s/\s\+$//e  " Auto-remove trailing spaces
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
set colorcolumn=80
" highlight ColorColumn ctermbg=0 guibg=darkgray
" Cobalt 2
  " highlight ColorColumn ctermbg=283 guibg=#283952
  " highlight cursorline ctermbg=283 guibg=#283952
" set list                                " Show whitespace characters
" set listchars=tab:▸\ ,eol:¬
"-----------------------------MAPPINGS-----------------------------"
"Add simple highlight removal. [,space]
nmap <Leader><space> :nohlsearch<cr>
"Sort selected alphabeticaly
noremap <Leader>s :sort<cr>
"map <D-§> :NERDTreeToggle<CR> "Does not work unfortunatly
map <C-n> :NERDTreeToggle<CR>
"nnoremap <C-§> :NERDTreeToggle<CR>
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

nnoremap <silent> <C-S> :<C-u>Update<CR>
"-------------Auto-Commands--------------"
"Automatically source the Vimrc file on save.
augroup autosourcing
    autocmd!
    autocmd BufWritePost .vimrc source %
augroup END

" Fix syntax not being set 
autocmd BufNewFile,BufRead *.vue set ft=vue
autocmd BufNewFile,BufRead *.scss set ft=scss

function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction

autocmd FileType php inoremap <Leader>n <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>n :call PhpInsertUse()<CR>


"-----------------------------Commands-----------------------------"
command! -nargs=1 Gv execute "!npm run generate:view" string(<q-args>)
command! -nargs=1 Gc execute "!npm run generate:component" string(<q-args>)
command! -nargs=1 Ge execute "!npm run generate:element" string(<q-args>)
command! -nargs=1 Gt execute "!npm run generate:test" string(<q-args>)
command! T execute "!npm --no-color run unit"

"-----------------------------PLUGIN SETTINGS-----------------------------"
" CTRLP
set wildignore+=*/tmp/*,*/node_modules/*,*/cache/*,*.so,*.swp,*.zip

" NERDTree
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg']
let g:NERDTreeWinPos = "right"
" Don't use fancy arrows (for bash on windows)
" let g:NERDTreeDirArrows=0

" Airline
let g:airline_theme='sol'
let g:airline#extensions#tabline#enabled = 0


" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1


let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute " ," attribute name ", "trimming empty \<", "inserting implicit ", "unescaped \&" , "lacks \"action", "lacks value", "lacks \"src", "is not recognized!", "discarding unexpected", "replacing obsolete "]

let g:syntastic_sass_checkers=["sasslint"]
let g:syntastic_scss_checkers=["sasslint"]

let g:syntastic_typescript_checkers=["tslint"]

" Typescript
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript

" Emmet
let g:user_emmet_expandabbr_key='<Tab>'
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" Autoclose
let g:AutoClosePumvisible = {"ENTER": "", "ESC": ""}

" Prettier
" none|es5|all
let g:prettier#config#trailing_comma = 'es5'
" print spaces between brackets
let g:prettier#config#bracket_spacing = 'true' 

" Youcompleteme
let g:ycm_filetype_blacklist = { 'html': 1, 'css': 1 }

if has("gui_macvim")
    macmenu &File.Print key=<nop>
    " set transparency=5
endif
