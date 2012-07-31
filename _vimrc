" http://brilliantcorners.org/2011/02/building-vim-on-osx-snow-leopard/

call pathogen#infect("~/bundle")
call pathogen#runtime_append_all_bundles()

" vim-slime
let g:slime_target = "tmux"

" http://tbaggery.com/2011/08/08/effortless-ctags-with-git.html

" from https://wincent.com/blog/tweaking-command-t-and-vim-for-use-in-the-terminal-and-tmux
set ttimeoutlen=50
if &term =~ "xterm" || &term =~ "screen"
  let g:CommandTCancelMap     = ['<ESC>', '<C-c>']
  let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<ESC>OB']
  let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<ESC>OA']
endif

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

let mapleader=","
" Remember more commands and search history

" autocmd BufRead,BufNewFile *.html source ~/.vim/indent/html_grb.vim
" autocmd FileType htmldjango source ~/.vim/indent/html_grb.vim
set history=1000

" Make tab completion for files/buffers act like bash
set wildmenu

" Make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase

" Keep more context when scrolling off the end of a buffer
set scrolloff=3

" Store temporary files in a central spot
set backupdir=~/.vim-tmp
set directory=~/.vim-tmp,c:\temp\vim

augroup myfiletypes
  "clear old autocmds in group
  autocmd!
  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et
augroup END

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  " set guifont=Monaco:h14
  set guifont=Inconsolata-dz:h14
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
" set smartindent
set laststatus=2
set showmatch
set incsearch

" GRB: wrap lines at 78 characters
" set textwidth=78

" GRB: Highlight long lines
" Turn long-line highlighting off when entering all files, then on when
" entering certain files. I don't understand why :match is so stupid that
" setting highlighting when entering a .rb file will cause e.g. a quickfix
" window opened later to have the same match. There doesn't seem to be any way
" to localize it to a file type.
" function! HighlightLongLines()
"   hi LongLine guifg=NONE guibg=NONE gui=undercurl ctermfg=white ctermbg=red cterm=NONE guisp=#FF6C60 " undercurl color
" endfunction
" function! StopHighlightingLongLines()
"   hi LongLine guifg=NONE guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guisp=NONE
" endfunction
" autocmd TabEnter,WinEnter,BufWinEnter * call StopHighlightingLongLines()
" autocmd TabEnter,WinEnter,BufWinEnter *.rb,*.py call HighlightLongLines()
" hi LongLine guifg=NONE
" match LongLine '\%>78v.\+'

" GRB: highlighting search"
set hls

if has("gui_running")
  " GRB: set font"
  ":set nomacatsui anti enc=utf-8 gfn=Monaco:h12

  " GRB: set window size"
  :set lines=100
  :set columns=171

  " GRB: highlight current line"
  ":set cursorline
endif

" GRB: set the color scheme
:set t_Co=256 " 256 colors
:set background=light
:color slate

" GRB: hide the toolbar in GUI mode
if has("gui_running")
    set go-=T
end

" GRB: use emacs-style tab completion when selecting files, etc
set wildmode=longest,list

" GRB: Put useful info in status line
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" GRB: clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" When hitting <;>, complete a snippet if there is one; else, insert an actual
" <;>
function! InsertSnippetWrapper()
    let inserted = TriggerSnippet()
    if inserted == "\<tab>"
        return ";"
    else
        return inserted
    endif
endfunction


" highlight current line
" set cursorline

" set cmdheight=2

" Don't show scroll bars in the GUI
set guioptions-=L
set guioptions-=r

set switchbuf=useopen

" Map ,e and ,v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'))
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

set number
set numberwidth=5

if has("gui_running")
endif



" " Find comment
map <leader>/# /^ *#<cr>
" " Find function
map <leader>/f /^ *def\><cr>
" " Find class
map <leader>/c /^ *class\><cr>
" " Find if
map <leader>/i /^ *if\><cr>

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

" Always show tab bar
set showtabline=2

map <silent> <leader>y :<C-u>silent '<,'>w !pbcopy<CR>

" Make <leader>' switch between ' and "
nnoremap <leader>' ""yls<c-r>={'"': "'", "'": '"'}[@"]<cr><esc>

" Map keys to go to specific files
map <leader>gr :topleft :split config/routes.rb<cr>
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gp :CommandTFlush<cr>\|:CommandT public<cr>
map <leader>gs :CommandTFlush<cr>\|:CommandT public/stylesheets/sass<cr>
map <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>
map <leader>gg :topleft 100 :split Gemfile<cr>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>

nnoremap <leader><leader> <c-^>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Running tests
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <leader>t :call TestFile( 0 )<CR>
map <leader>T :call TestFile( 1 )<CR>
map <leader>a :call TestRun()<CR>

function! TestFile(only_selected)
    :w
    let test_file   = substitute(@%,"\\","/","g")
    let separator   = has("win32") ? "\\;" : ":"
    let t:test_last = ":!ruby -Ilib" . separator . "test " . test_file 
    if a:only_selected 
      let t:test_last = t:test_last . TestExampleParameter()
    endif
    call TestRun()
endfunction

function! TestRun()
    exec t:test_last
endfunction

" find testname from "it '#bleeds' do" line
function! TestExampleParameter()
  execute "normal mt"
  ?\v^\s+it\s
  let cur_line = getline(".")
  execute "normal `t"
  return " '-n /" . matchstr(cur_line, '\v^\s+it\W+\zs\w+\ze\W+do$') . "/'"
endfunction

set winwidth=84
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
"set winheight=5
"set winminheight=5
"set winheight=999

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <c-n> :let &wh = (&wh == 999 ? 10 : 999)<CR><C-W>=


command! -range Md5 :echo system('echo '.shellescape(join(getline(<line1>, <line2>), '\n')) . '| md5')

imap <c-l> <space>=><space>

set shell=bash

" Can't be bothered to understand the difference between ESC and <c-c> in
" insert mode
imap <c-c> <esc>

command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>

