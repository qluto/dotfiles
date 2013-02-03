set nocompatible

filetype plugin on

if filereadable(expand('~/.vimrc.bundle'))
    source ~/.vimrc.bundle
endif

"" General
set fileformats=unix,dos,mac
set visualbell t_vb= " no more beep
set backspace=indent,eol,start
set wildmode=list:longest

setlocal omnifunc=syntaxcomplete#Complete

"" backup settings
set backup
set backupdir=$HOME/.vim/backup
set swapfile
set backupdir=$HOME/.vim/swap
autocmd BufRead /tmp/crontab.* :set nobackup nowritebackup

"" Folding
set fdm=marker
let php_folding=1
let perl_fold=1
let perl_noforld_packages=1
au Syntax php set fdm=syntax
au Syntax perl set fdm=syntax

"" nohilight keybind
nnoremap <ESC><ESC> :nohlsearch<CR>

"" 全角スペースを可視化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
match ZenkakuSpace /　/

"" Encoding
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp,sjis
if exists('&ambiwidth')
  set ambiwidth=double
endif

"" Search
set history=100
" 検索文字列が小文字の場合は大文字小文字を区別なく検索
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索
set smartcase
" 検索結果をハイライト
set hlsearch
" インクリメンタルサーチ
set incsearch

set wrapscan


" タイプ別関数呼び出し
"au FileType perl call PerlType()
filetype plugin indent on
autocmd! BufRead,BufNewFile *.inc set filetype=php
autocmd! BufRead,BufNewFile *.cgi set filetype=perl
autocmd! BufRead,BufNewFile *.pass setlocal nobackup

"" display settings
set title
set number
set ruler
set list
set listchars=tab:->,extends:<,trail:_ " visualize tab and space in the end of a line
set showcmd
set laststatus=2
set showmatch
set matchtime=2
set wildmode=full:list
set scrolloff=5
set wildmenu
set textwidth=0
set wrap

set autowrite
set directory=/tmp

"" show status line
"set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set statusline=%n\:%y%F\ \|%{(&fenc!=''?&fenc:&enc).'\|'.&ff.'\|'}%m%r%=<%l/%L:%p%%>
highlight StatusLine    term=NONE cterm=NONE ctermfg=black ctermbg=white

"" indent settings
set noautoindent
set nosmartindent
set cindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
if has("autocmd")
  autocmd FileType *
  \ let &l:comments
  \=join(filter(split(&l:comments, ','), 'v:val =~ "^[sme]"'), ',')
endif

"" for python
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=4 expandtab shiftwidth=4 softtabstop=4

"" for ejs
"au BufNewFile,BufRead *.ejs set filetype=javascript
au BufRead,BufNewFile *.ejs setfiletype html


"" php syntax check
"" where you want to syntax check, type ':make'.
autocmd FileType php set makeprg=php\ -l\ %
autocmd FileType php set errorformat=%m\ in\ %f\ on\ line\ %l

"" perl syntax check
autocmd FileType perl set makeprg=perl\ -cw\ %
autocmd FileType perl set errorformat=%m\ in\ %f\ on\ line\ %l

"" allow vim to use directory
set complete+=k


" 日付の挿入
" \dateで使える
inoremap <Leader>date <C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>

"" for ctags
nnoremap <C-p> :pop<CR>
set tags+=.tags

"" other local settings
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
