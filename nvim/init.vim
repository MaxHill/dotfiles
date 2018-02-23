"-----------------------------PLUGINS-----------------------------"
call plug#begin('~/.config/nvim/plugged')

Plug 'vim-syntastic/syntastic'
Plug 'mtscout6/syntastic-local-eslint.vim'
Plug 'sekel/vim-vue-syntastic'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'mattn/emmet-vim'
Plug 'StanAngeloff/php.vim'
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
Plug 'prettier/vim-prettier'
Plug 'mileszs/ack.vim'
Plug 'pangloss/vim-javascript'
Plug 'christoomey/vim-tmux-navigator'
Plug 'hail2u/vim-css3-syntax'
Plug 'Shougo/vimproc.vim', { 'do': 'make -f make_mac.mak' }
Plug 'neomake/neomake'

call plug#end() " All of your Plugins must be added before the following line
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


" Add python
let g:python2_host_prog = '/usr/local/bin/python'
" let g:python3_host_prog = '/usr/local/bin/python3'
" let &colorcolumn=join(range(81,999),",")      " Highlight everything after 80 chars

highlight ColorColumn ctermbg=246 guibg=#2c2d27 " Set the color of the 80 char mark
highlight clear SignColumn

"-----------------------------MAPPINGS-----------------------------"
" Add simple highlight removal. [,space]
nmap <Leader><space> :nohlsearch<cr>
" Sort selected alphabeticaly
noremap <Leader>s :sort<cr>
map <C-n> :NERDTreeToggle<CR>
map <D-r> :CtrlPBufTag<CR>
nmap <C-p> :CtrlPMRUFiles<cr>
map ,ev :tabedit ~/.config/nvim/init.vim
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
command! -nargs=1 Gv execute "!npm run generate:view" string(<q-args>)
command! -nargs=1 Gc execute "!npm run generate:component" string(<q-args>)
command! -nargs=1 Ge execute "!npm run generate:element" string(<q-args>)
command! -nargs=1 Gt execute "!npm run generate:test" string(<q-args>)
command! T execute "!npm --no-color run unit"

"-----------------------------PLUGIN SETTINGS-----------------------------"
" CTRLP
set wildignore+=*/tmp/*,*/node_modules/*,*/cache/*,*.so,*.swp,*.zip
let g:ctrlp_cmd = 'CtrlPMRU'

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
" let g:NERDTreeDirArrows=0 " Don't use fancy arrows (for bash on windows)

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
let g:syntastic_error_symbol = '✗✗'
let g:syntastic_style_error_symbol = '✠✠'
let g:syntastic_warning_symbol = '∆∆'
let g:syntastic_style_warning_symbol = '≈≈'
highlight link SyntasticErrorSign SpellBad
highlight link SyntasticWarningSign SpellBad
highlight link SyntasticStyleErrorSign SpellCap
highlight link SyntasticStyleWarningSign SepllCap

let g:syntastic_html_tidy_ignore_errors=["plain text isn't allowed in <head> elements"," proprietary attribute " ," attribute name ", "trimming empty \<", "inserting implicit ", "unescaped \&" , "lacks \"action", "lacks value", "lacks \"src", "is not recognized!", "discarding unexpected", "replacing obsolete "]

let g:syntastic_sass_checkers=["sasslint"]
let g:syntastic_scss_checkers=["sasslint"]

let g:tsuquyomi_disable_quickfix = 1
" let g:syntastic_typescript_checkers=["tslint"]
let g:syntastic_typescript_checkers=[""]

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
