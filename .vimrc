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
set sw=8
set ts=8
set noshowmatch
let g:loaded_matchparen = 1

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
"Plugin 'Valloric/YouCompleteMe'
call vundle#end()            " required
filetype plugin indent on    " required

colorscheme molokai
set bg=dark
"let g:molokai_original = 1
let g:rehash256 = 1

let mapleader = "-"

" YCM
"let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
"let g:ycm_autoclose_preview_window_after_insertion = 1
"nnoremap <leader>jd :YcmCompleter GoTo<CR>

" NERDTree
" autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nnoremap <leader>ns :NERDTree<cr>
nnoremap <leader>nt :NERDTreeToggle<cr>

" ctrlp.vim
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|o|ta|elf)$',
  \ }
let g:ctrlp_by_filename = 1
" \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',

" Spot extra whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match Error /\s\+$/

" Mail
autocmd FileType mail set spell

" Git
au FileType gitcommit setlocal tw=72

" Freeplane
au BufRead,BufNewFile *.mm set filetype=xml

" Rst
au BufRead,BufNewFile *.rst set ts=4 tw=80 sw=4

" Python
nnoremap <leader>pr :w<cr>:exec '!python' shellescape(@%, 1)<cr>

nnoremap <leader>m :wa<CR>:make<CR>
map <F7> <ESC>:wa<CR>:make<CR>

nnoremap <leader>s :source ~/.vimrc<CR>
nnoremap <leader>e :e ~/.vimrc<CR>

map <C-down> :bp<CR>
map <C-up>   :bn<CR>


" Gtags etc
let GtagsCscope_Auto_Load = 1
let GtagsCscope_Auto_Map = 1
let GtagsCscope_Quiet = 1
set cscopetag

" Update GTAGS database everytime you save the file.
autocmd BufWritePost *.c,*.h silent exec '! if [ -f GTAGS ]; then global -u; fi'

nnoremap <leader>cc :cscope f c <cword><cr>zz
nnoremap <leader>ce :cscope f e <cword><cr>zz
nnoremap <leader>cf :cscope f f  
nnoremap <leader>cg :cscope f g <cword><cr>zz
nnoremap <leader>ci :cscope f i <cword>.h<cr>zz
nnoremap <leader>cs :cscope f s <cword><cr>zz

function! LoadCscope()
	let db = findfile("cscope.out", ".;")
	if (!empty(db))
		let path = strpart(db, 0, match(db, "/cscope.out$"))
		set nocscopeverbose " suppress 'duplicate connection' error
		exe "cs add " . db . " " . path
		set cscopeverbose
	endif
endfunction

function! LoadGtags()
	let db = findfile("GTAGS", ".;")
	if (!empty(db))
		let path = strpart(db, 0, match(db, "/GTAGS$"))
		set nocscopeverbose " suppress 'duplicate connection' error
		exe "cs add " . db . " " . path
		"set cscopeverbose
	endif
endfunction
