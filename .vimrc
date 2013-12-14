set nocompatible		" This isn't automatically set when using -u
filetype plugin indent on
set backspace=indent,eol,start	" allow backspacing over everything in insert mode

set noruler			" don't show the cursor position all the time (ls is on)
set showcmd			" display incomplete commands
set incsearch

set backupcopy=yes

set number
set cindent
set autoindent
set mouse=a			" use mouse in xterm to scroll
set mousefocus			" focus follows mouse
set scrolloff=5 		" 5 lines before and after the current line when scrolling
set display=lastline		" Display incomplete lines instead of a bunch of @
set ignorecase			" ignore case
set smartcase			" but only sometimes
set hls
set hid 			" allow switching buffers, which have unsaved changes
set showmatch
set formatoptions=crnql
set wrap
set completeopt=menu,longest,preview
set lbr				" wrap at breaks in long lines
set wim=list:longest
set shm=ilmr
set report=0
set ls=2			" puts the bar on the bottom
set stl=%t\ %R%m\ %Y\ \#%n\ \ %7l\/%-7L\ \ %c%V%=%B\ %3p%%\ 
set dip=filler,iwhite
set cinoptions=g0t0:0
set visualbell
set ttyfast
set grepprg="grep -nH $*"
set spellfile=~/.vim/custom.UTF-8.add
"set spell
syn on
imap <C-l> <C-o><C-l>
nmap Y y$
let c_space_errors = 1
let c_gnu = 1
let c_no_curly_error = 1
let g:is_bash = 1
let g:tex_flavor = "latex"

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
