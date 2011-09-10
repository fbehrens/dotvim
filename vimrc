set nocompatible
silent! call pathogen#runtime_append_all_bundles()

set hidden    "its possible to have unsaved changes in a hidden buffer
set number    "show linenumbers
set ruler
syntax on

runtime macros/matchit.vim        " Load the matchit plugin.(required for textobj-rubyblocks

" Automatic fold settings for specific files. 
autocmd FileType ruby set foldmethod=syntax
" autocmd FileType css  setlocal foldmethod=indent shiftwidth=2 tabstop=2

" Set encoding
set encoding=utf-8
let mapleader = ","

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
"set list listchars=tab:\ \ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc

" Status bar
set laststatus=2

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

let NERDTreeIgnore=['\.rbc$', '\~$']

let g:CommandTMaxHeight=20


" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

function s:setupWrapping()
  set wrap
  set wm=2
  set textwidth=72
endfunction

function s:setupMarkup()
  call s:setupWrapping()
  map <buffer> <Leader>p :Mm <CR>
endfunction

" make and python use real tabs
au FileType make                                     set noexpandtab
au FileType python                                   set noexpandtab

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

au BufRead,BufNewFile *.txt call s:setupWrapping()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
" map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>


" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
syntax enable
let g:solarized_termcolors=256
set t_Co=256
set cul
"16
color solarized
set background=dark
"color desert

" paste text after using F2
set pastetoggle=<F2>

" Include user's local vim config
if filereadable(expand("~/.vim/vimrc.local"))
  source ~/.vim/vimrc.local
endif

" function! GuiTabLabel()
  " return get( split( getcwd(),"\\") ,-1)
"endfunction

set guitablabel=%{GuiTabLabel()}
"set tabline=%{GuiTabLabel()}
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

map <Leader>n :NERDTreeToggle<CR>
map <Leader>q :ZoomWin<CR>
map <Leader>ct :!ctags --extra=+f -R *<CR><CR>
nnoremap <silent> <F8> :TlistToggle<CR>
map <Leader><Leader> <C-^>
map <Leader><TAB> <C-w>p

" split window with one maximised
set winheight=5
set winminheight=5
set winheight=999

" refreshed files on opening
set autoread

if has("win32")
  let g:snippets_dir=$VIM . "\\snippets\\"
  set backupdir=c:\prog\vim\backup
  set directory=c:\prog\vim\backup
  
  imap <M-f> <Esc>:CommandT<CR>
  map <M-f> :CommandT<CR>
  map <M-/> <plug>NERDCommenterToggle<CR>
  
else "mac or linux

  let g:snippets_dir="~/.vim/snippets/"
  set backupdir=~/.vim_backup
  set directory=~/.vim_backup

  if has("gui_macvim")
    map <D-t> :CommandT<CR>
    imap <D-t> <Esc>:CommandT<CR>
    map <D-/> <plug>NERDCommenterToggle<CR>
  else "linux 
    map  <Esc>0 0gt
    imap <Esc>0 <Esc>0gt
    map  <Esc>1 1gt
    imap <Esc>1 <Esc>1gt
    map  <Esc>2 2gt
    imap <Esc>2 <Esc>2gt
    map  <Esc>3 3gt
    imap <Esc>3 <Esc>3gt
    map  <Esc>1 1gt
    imap <Esc>1 <Esc>1gt
    map <Esc>t :CommandT<CR>
    map <Esc>/ <plug>NERDCommenterToggle<CR>
    " ranger
    fun! Ranger()
      silent !ranger --choosefile=/tmp/chosen
      if filereadable('/tmp/chosen')
        exec 'edit ' . system('cat /tmp/chosen')
        call system('rm /tmp/chosen')
      endif
      redraw!
    endfun
    map <leader>r :call Ranger()<CR>
  endif
endif
