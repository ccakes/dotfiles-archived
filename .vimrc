colorscheme cakes

set nocompatible
set clipboard=unnamed
set wildmenu
set esckeys
set backspace=indent,eol,start
set ttyfast
set gdefault
set encoding=utf-8 nobomb
let mapleader=","
set binary
set noeol

set modeline
set modelines=4
set exrc
set secure
set number
syntax on
set cursorline
set tabstop=4
set expandtab
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set mouse=a
set noerrorbells
set nostartofline
set ruler
set showmode
set title
set showcmd
set scrolloff=5

" Automatic commands
if has("autocmd")
	filetype on
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
endif
