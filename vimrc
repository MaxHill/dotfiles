"-----------------------------PLUGINS-----------------------------"
if has("win32")
    set rtp+=%HOME%/vimfiles/bundle/Vundle.vim
    call vundle#begin('%USERPROFILE%/vimfiles/bundle')
else
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin() 
endif

Plugin 'VundleVim/Vundle.vim' " let Vundle manage Vundle, required
" Plugin 'scrooloose/syntastic' " Old
Plugin 'vim-syntastic/syntastic'
Plugin 'mtscout6/syntastic-local-eslint.vim'
Plugin 'sekel/vim-vue-syntastic'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'mattn/emmet-vim'
Plugin 'StanAngeloff/php.vim'
Plugin 'posva/vim-vue'
Plugin 'jdkanani/vim-material-theme'
Plugin 'jiangmiao/auto-pairs'
Plugin 'leafgarland/typescript-vim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'digitaltoad/vim-pug'
Plugin 'tpope/vim-surround'
Plugin 'wincent/terminus'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'gcorne/vim-sass-lint'
Plugin 'dkprice/vim-easygrep'
Plugin 'Valloric/YouCompleteMe'
Plugin 'prettier/vim-prettier'
Plugin 'mileszs/ack.vim'


call vundle#end() " All of your Plugins must be added before the following line
filetype plugin indent on    " Required by vundle

"-----------------------------GENERAL SETTINGS-----------------------------"
set nocompatible   " Disable vi-compatibility
filetype off      " required
filetype plugin on
syntax on
set background=dark

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
set colorcolumn=81                      " Highlight to column to see 80 char mark
set complete+=kspell                    " Autocomplete with dictionary words when spell check is on
set list listchars=tab:»·,trail:·,nbsp:·
set timeoutlen=1000 ttimeoutlen=0       " Remove timout for escape

" let &colorcolumn=join(range(81,999),",")      " Highlight everything after 80 chars
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

" Fix syntax not being set 
autocmd BufNewFile,BufRead *.vue set ft=vue
autocmd BufNewFile,BufRead *.scss set ft=scss

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
" let g:NERDTreeDirArrows=0 " Don't use fancy arrows (for bash on windows)

" Airline
let g:airline_theme='sol'
let g:airline#extensions#tabline#enabled = 0


" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '💩'
highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute " ," attribute name ", "trimming empty \<", "inserting implicit ", "unescaped \&" , "lacks \"action", "lacks value", "lacks \"src", "is not recognized!", "discarding unexpected", "replacing obsolete "]

let g:syntastic_sass_checkers=["sasslint"]
let g:syntastic_scss_checkers=["sasslint"]

let g:syntastic_typescript_checkers=["tslint"]

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_vue_checkers = ['eslint']
let local_eslint = finddir('node_modules', '.;') . '/.bin/eslint'
if matchstr(local_eslint, "^\/\\w") == ''
    let local_eslint = getcwd() . "/" . local_eslint
endif
if executable(local_eslint)
    let g:syntastic_javascript_eslint_exec = local_eslint
    let g:syntastic_vue_eslint_exec = local_eslint
  endif

" Typescript
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript

" Emmet
let g:user_emmet_expandabbr_key='<Tab>'
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

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
    colorscheme material-theme
endif
