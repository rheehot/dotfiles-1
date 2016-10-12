" Daybreaker's vimrc
" Maintainer: Joongi Kim (me@daybreaker.info)

set nocompatible
scripte utf-8
let $LANG='ko_KR.UTF-8'
set enc=utf-8

" Vundle package manager
filetype off
if has("win32")
  set rtp+=~/vimfiles/bundle/Vundle.vim/
  let path='~/vimfiles/bundle'
  call vundle#begin(path)
else
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
endif

Plugin 'gmarik/Vundle.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'airblade/vim-gitgutter'
let g:airline_powerline_fonts = 1
Plugin 'bling/vim-airline'
set laststatus=2  " always show airline
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-surround'
let g:vim_markdown_folding_disabled = 1
Plugin 'plasticboy/vim-markdown'
Plugin 'nvie/vim-flake8'
Plugin 'hdima/python-syntax'
let g:python_highlight_exceptions = 1
"let g:python_highlight_builtin_funcs = 1
"let g:python_highlight_print_as_function = 1
Plugin 'pangloss/vim-javascript'
Plugin 'JuliaLang/julia-vim'
Plugin 'fatih/vim-go'
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1

call vundle#end()
filetype plugin on

syntax on
autocmd BufWinEnter * syntax sync minlines=100 maxlines=500 linebreaks=10

%if vim_colorscheme == "solarized":
let g:solarized_contrast="high"
%end

" gVim-specific options
if has("gui_running")

  " Hide scroll bars always
  set go-=r go-=L

  " Toggle menu/tool bars
  function s:MenuBar()
    if stridx(&guioptions, 'm') == -1
      set go+=T go+=m
    else
      set go-=T go-=m
    endif
  endfunction
  map <silent> <F10> :call <SID>MenuBar()<cr>
  call <SID>MenuBar()
  winsize 122 60
  inoremap <ESC> <ESC>:set iminsert=0<CR>

  " Windows-specific options
  if has("win32")
    source $VIMRUNTIME/delmenu.vim
    set langmenu=ko_kr
    source $VIMRUNTIME/menu.vim
    colorscheme {{vim_colorscheme}}
    set guifont=Hack:h10:cANSI
    set guifontwide=NanumGothicCoding:h10:cDEFAULT
  endif
endif

" MacVim-specific options
if has("gui_macvim")
  colorscheme {{vim_colorscheme}}
  set guifont=Menlo\ for\ Powerline:h12
  set fuopt+=maxvert
  set fuopt+=maxhorz
  set columns=122 lines=60
  set go-=T
  set transparency=0
endif

" Terminal-specific options
if !has("gui_running")
  if has("win32")
    let s:tty="/dev/pts/0"  " emulate
  elseif $TERM_PROGRAM == 'Apple_Terminal' || $TERM_PROGRAM =~ "iTerm\.app" || $TERM_PROGRAM == 'HyperTerm'
    let s:tty="/dev/pts/0"  " emulate
  else
    " The environment variable TTY is set by the shell (see bashrc).
    " Vim's system() function uses redirection and thus the result is
    " 'not a tty' error instead of the actual tty name.
    let s:tty=$TTY
  endif
  set bg=dark
%if vim_colorscheme == "solarized":
  let g:solarized_termcolors=16
  let g:solarized_bold=0
  " Note: solarized recommends use of terminal color setting instead of
  " degraded 256-color mode.
%end
  if s:tty=~"/pts/" && ($TERM =~ "-256color$" || $TERM == "linux")

    if has("nvim")
      let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    else
      set t_Co=256 termguicolors term=xterm-256color
    endif

    " Disable BCE for 256-color tmux/screen terminals.
    " More details - https://sunaku.github.io/vim-256color-bce.html
    set t_ut=

    colorscheme {{vim_colorscheme}}
    highlight Comment gui=italic cterm=italic
  else
    colorscheme default
  endif
  if $TERM =~ '^screen' || $TERM =~ '^tmux'
    map <Esc>[1~ <Home>
    map! <Esc>[1~ <Home>
    map <Esc>[4~ <End>
    map! <Esc>[4~ <End>
  endif
endif

set tenc=utf-8 fencs=utf-8,utf-16le,cp949,latin1 fenc=utf-8
set ts=8 sw=4 sts=4 noet tw=0
set hlsearch
set autoindent copyindent nosmartindent nocindent
if exists('+breakindent')
  set breakindent
endif
set wmnu nu nuw=5 ruler
set modeline
set ignorecase smartcase
set scrolloff=2
set backspace=indent,eol,start
set cursorline

function MyHomeKey()
  let l:column = col('.')
  execute "normal ^"
  if l:column == col('.')
    execute "normal 0"
  endif
endfunction

" Show man pages inside vim like :help command.
source $VIMRUNTIME/ftplugin/man.vim
nmap K :Man <cword><cr>

set timeout timeoutlen=3000 ttimeoutlen=100
map j gj
map k gk
map <Down> gj
map <Up> gk
" search by visual block content
vmap // "vy/<C-R>v<cr>
" NOTE: <Home> key may be different on variouse terminals.
imap <silent> [1~ <C-O>:call MyHomeKey()<cr>
map <silent> [1~ :call MyHomeKey()<cr>
" prevent removing indents before # when typing # after indents and smartindent is on (mostly occurs in Python)
inoremap # X#

set mouse=a

" vim: ts=8 sts=2 sw=2 et
