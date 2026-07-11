" Minimal, plugin-free vimrc for quick terminal edits.
" (Primary editing happens in JetBrains/VS Code; this keeps vim pleasant
" without a plugin manager to maintain.)

set nocompatible
syntax enable
filetype plugin indent on

" UI
set number              " show line numbers
set relativenumber      " relative numbers for easy motions
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when needed
set showmatch           " highlight matching [{()}]
set laststatus=2        " always show the status line
set ruler               " cursor position in status line
set scrolloff=4         " keep context lines visible when scrolling
set display=lastline    " show as much of a long line as fits

" Search
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase          " case-insensitive search...
set smartcase           " ...unless the pattern has capitals
" clear search highlight
nnoremap <silent> <leader><space> :nohlsearch<CR>

" Indentation
set tabstop=4           " visual spaces per tab
set softtabstop=4       " spaces per tab when editing
set shiftwidth=4        " spaces per indent step
set expandtab           " tabs are spaces
set autoindent

" Behavior
set hidden              " allow switching buffers without saving
set backspace=indent,eol,start
set mouse=a             " mouse support in all modes
set clipboard=unnamed   " use the macOS clipboard
set ttimeoutlen=50      " snappy escape from insert mode
set updatetime=300

" Files
set encoding=utf-8
set nobackup            " no backup/swap clutter; rely on git
set noswapfile
set undofile            " but DO keep persistent undo
set undodir=~/.vim/undo//
if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p', 0700)
endif

" Leader shortcuts
let mapleader=","
" jk is escape
inoremap jk <esc>
" edit/reload vimrc
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Filetype tweaks
augroup configgroup
  autocmd!
  autocmd FileType ruby,yaml,json,javascript,typescript,vue setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd BufEnter Makefile setlocal noexpandtab
  autocmd BufEnter *.sh setlocal tabstop=2 shiftwidth=2 softtabstop=2
  " strip trailing whitespace on save for code files
  autocmd BufWritePre *.php,*.py,*.js,*.ts,*.vue,*.sh,*.md :%s/\s\+$//e
augroup END
