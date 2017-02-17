syn on
set autoindent
set autoread
set bs=2
set cindent
set cinoptions=(0,u0,U0
set hidden
set hlsearch
set ignorecase
set incsearch
set mat=2
set nobackup
set noexpandtab
set nonumber
set nojoinspaces
set ruler
set showmatch
set smartcase
set smartindent
"set smarttab
set sw=8
set t_Co=256
set ts=8
set tw=80
set sts=0

" For swp-files
set dir=~/tmp//


" In 7.3.74 set this to make "+y and/or "*y to work
"set clipboard=unnamedplus

"Hide some files
let g:explHideFiles='^\.,.*\.class$,.*\.swp$,.*\.o$,.*\.d$,\.DS_Store$'
let g:netrw_list_hide= '.*\.o$,.*\.cmd$,\~$,\.orig$,.*\.ko$'

set laststatus=2
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
"set statusline=[%n]\ %<%.99f\ %h%w%m%r%{exists('*CapsLockStatusline')?CapsLockStatusline():''}%y%=%-16(\ %l,%c-%v\ %)%P

execute pathogen#infect()

set nocp
filetype plugin on
filetype plugin indent on
set bg=dark

colorscheme solarized
"colorscheme default

"if &term == "xterm"
"	colorscheme default
"else
"	let g:solarized_termcolors=256
"	colorscheme solarized
"	colorscheme github
"endif

hi Pmenu guibg=#333333
hi PmenuSel guibg=#555555 guifg=#ffffff

autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd Filetype cpp map <buffer> _c :w<CR>:!g++ %<CR>
autocmd Filetype c   map <buffer> _c :w<CR>:!gcc %<CR>
autocmd FileType mail set spell
au FileType gitcommit setlocal tw=72
"2autocmd FileType md so ~/.vim/after/ftplugin/markdown/folding.vim
au BufRead,BufNewFile *.php set ft=php.html

map _gt :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
map _m :wa<CR>:make<CR>
map <F7> <ESC>:wa<CR>:make<CR>
map <F12> :cscope f s <cword><CR>

map _s :source ~/.vimrc<CR>
map _e :e ~/.vimrc<CR>

map <C-down> :bp<CR>
map <C-up>   :bn<CR>

"match Error /\%>80v.\+/

"inoremap $1 ()<esc>:let leavechar=")"<cr>i
"
let GtagsCscope_Auto_Load = 1
let GtagsCscope_Auto_Map = 1
let GtagsCscope_Quiet = 1
set cscopetag
"
map <C-g> :cscope f g <cword>
map <C-c> :cscope f c <cword><cr>

" vimwiki
let wiki = {}
let wiki.path = '~/vimwiki'
let wiki.nested_syntaxes = {'bash': 'sh', 'c': 'c', 'python': 'pl'}
let g:vimwiki_list = [wiki]

