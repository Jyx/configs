set nocompatible              " be iMproved, required
filetype off                  " required

syn on
set autoindent
set autoread
set bs=2
set cindent
set cinoptions=(0,u0,U0
set encoding=utf-8
set hls
set ignorecase
set incsearch
"set mouse=a
set nobackup
set noexpandtab
set nojoinspaces
set nonumber
set ruler
set showmatch
set smartcase
set smartindent
set smartindent
set sw=8
set ts=8

" For swp-files
set dir=~/tmp//

" Hide some files
let g:explHideFiles='^\.,.*\.class$,.*\.swp$,.*\.o$,.*\.d$,\.DS_Store$'
let g:netrw_list_hide= '.*\.o$,.*\.cmd$,\~$,\.orig$,.*\.ko$'

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'vim-airline/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Valloric/YouCompleteMe'
call vundle#end()            " required
filetype plugin indent on    " required

colorscheme molokai
set bg=dark
"let g:molokai_original = 1
let g:rehash256 = 1

" YCM
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

" NERDTree
" autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTree<cr>

" ctrlp.vim
let g:ctrlp_show_hidden = 1

" Spot extra whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match Error /\s\+$/

" Mail
autocmd FileType mail set spell

" Git
au FileType gitcommit setlocal tw=72

map _m :wa<CR>:make<CR>
map <F7> <ESC>:wa<CR>:make<CR>

map _s :source ~/.vimrc<CR>
map _e :e ~/.vimrc<CR>

map <C-down> :bp<CR>
map <C-up>   :bn<CR>

let GtagsCscope_Auto_Load = 1
let GtagsCscope_Auto_Map = 1
let GtagsCscope_Quiet = 1
set cscopetag
"
map <C-g> :cscope f g <cword>
map <C-c> :cscope f c <cword><cr>
