" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"                    GENERAL
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

""" Don't care to be compatible with vi circa 1976.
set nocompatible

set t_Co=256

""" Quickly edit and reload this file from anywhere.
cabbrev vconf new ~/.vimrc
cabbrev rev source ~/.vimrc

""" Turn off hard and soft line wrap.
set textwidth=0 wrapmargin=0 nowrap

""" Rolodex mode, vertical and horizontal
set noequalalways winheight=9999 helpheight=9999 winminheight=2

""" The final tab solution.
set tabstop=4 shiftwidth=4 expandtab autoindent

set fillchars=stl:\ ,stlnc:\ 

""" Save unlimited per-file undo history in appdata.
set undofile

""" Enable mouse
set ttymouse=xterm2
set mouse=a

""" STFU
set noeb vb t_vb=

""" Misc
set laststatus=1 noruler statusline=%=\ %f\ 
set hidden
set scrolloff=3
set splitright splitbelow
set foldcolumn=0
set ignorecase smartcase incsearch
set encoding=utf-8
set number numberwidth=5

""" Enable line numbers for all opened files, even help files.
augroup buffer_switch_settings
    autocmd!
    autocmd BufEnter * :set number
augroup END

" Update the window title when changing vim buffers.
function! UpdateTitle()
  let &titlestring='vim  '.expand("%:~")
  set t_ts=]2;
  set t_fs=\\
  set title
endfunction
augroup windowtitle
  autocmd!
  autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call UpdateTitle()
augroup END

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"                    KEYBINDS
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

""" Hit space to unhighlight search matches.
nn <Space> :nohlsearch<CR>:<C-c><Space>



" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"           COLOR THEME / HIGHLIGHTS
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

""" Highlight the first 80 columns.
let &colorcolumn="".join(range(1,80),",")
" set colorcolumn=80

""" Force dark mode
set bg=dark

""" Build an appropriate highlight command. The "NONE" before the variables
" clears the highlight completely without reverting to default.
function s:hi(group, fg, bg, attr)
    let s:c = "highlight! " .a:group ." NONE"
    if a:fg != ""   | let s:c .= " ctermfg=" .a:fg | endif
    if a:bg != ""   | let s:c .= " ctermbg=" .a:bg | endif
    if a:attr != "" | let s:c .= " cterm=" .a:attr | endif
    exec s:c
endfunction

""" NUKE ALL HIGHLIGHTS
"for hl_group in getcompletion('', 'highlight')
"   call s:hi(hl_group, "", "", "")
"endfor

" Diable bold fonts
set  t_md=
    
syntax enable
syntax reset

""" Vim UI highlights      foreground  background  attributes
call s:hi("ColorColumn",      "",         "233",      "")
" call s:hi("Normal",         s:dark,     s:light,    "")
" call s:hi("Folded",         s:grey1,    "",         "")
" call s:hi("FoldedColumn",   s:grey1,    "",         "")
" call s:hi("FoldColumn",      "",        "red",      "")
call s:hi("LineNr",           "8",    "",         "")
" call s:hi("Visual",         s:white,    s:grey1,    "")
call s:hi("EndOfBuffer",      "black",    "",         "")
call s:hi("StatusLine",       "14",     "black",    "")
call s:hi("StatusLineNC",     "8",    "black",    "")
" call s:hi("VertSplit",      s:light,    "",         "")
" call s:hi("MatchParen",     s:black,    s:attn_y,   "bold")
" call s:hi("Search",         "",         "",         "reverse")
" call s:hi("ErrorMsg",       s:orange,   "",         "reverse")
" call s:hi("Directory",      s:blue,     "",         "")
" call s:hi("MoreMsg",        s:blue,     "",         "")
" call s:hi("Question",       s:blue,     "",         "")
""" Syntax highlights      foreground  background  attributes
" call s:hi("Comment",        s:green,    "",         "")
" call s:hi("Constant",       s:green,    "",         "")
" call s:hi("Identifier",     s:dark,     "",         "")
" call s:hi("Statement",      s:orange,   "",         "")
" call s:hi("PreProc",        s:blue,     "",         "")
" call s:hi("Type",           s:dark,     "",         "")
" call s:hi("Special",        s:dark,     "",         "")
" call s:hi("Underlined",     s:magenta,  "",         "")
" call s:hi("Ignore",         s:orange,   "",         "bold,reverse")
" call s:hi("Error",          s:orange,   "",         "bold")
" call s:hi("Todo",           s:orange,   "",         "bold")

delfunction s:hi
