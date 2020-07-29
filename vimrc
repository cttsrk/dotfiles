" Don't care to be compatible with vi circa 1976.
set nocompatible

" Quickly edit and reload this file from anywhere.
cabbrev vconf vert new ~/.vimrc
cabbrev rev source ~/.vimrc

" Save unlimited per-file undo history trees in appdata.
set undofile

set mouse=a
set lazyredraw
set noeb vb t_vb=
set laststatus=0 noruler
set hidden
set scrolloff=3
set splitright splitbelow
set foldcolumn=0 numberwidth=6
set tabstop=4 shiftwidth=4 expandtab autoindent
set ignorecase smartcase incsearch
set textwidth=78

" Highlight the first 80 columns.
let &colorcolumn="".join(range(1,80),",")

" Enable line numbers for all opened files, even help files.
augroup buffer_switch_settings
    autocmd!
    autocmd BufEnter * :set number
augroup END

" Terminal sanity on windows.
if (&term == "pcterm" || &term == "win32")
    set term=xterm t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    set termencoding=utf8
    ino <Char-0x07F> <BS>
    nn <Char-0x07F> <BS>
endif

"Trigger InsertLeave event when exiting insert mode with Control-C
ino <C-c> <Esc>

" Silence Control-C.
nn <C-c> :<C-c>

" Use space to unhighlight search matches.
nn <Space> :nohlsearch<CR>:<C-c><Space>

" Unbind keys that encourage suboptimal use patterns ("vim hardmode").
no  <Home>      <Nop>
no  <End>       <Nop>
no  <Insert>    <Nop>
no  <BS>        <Nop>
no  <Up>        <Nop>
no  <Down>      <Nop>
no  <Left>      <Nop>
no  <Right>     <Nop>
nn  h           <Nop>
nn  j           <Nop>
nn  k           <Nop>
nn  l           <Nop>
no! <Home>      <Nop>
no! <End>       <Nop>
no! <Insert>    <Nop>
no! <BS>        <Nop>
no! <Up>        <Nop>
no! <Down>      <Nop>
no! <Left>      <Nop>
no! <Right>     <Nop>

" Set the terminal title to "filename".
function! UpdateTitle()
  let &titlestring="".fnamemodify(expand("%"),":~")
  set title
endfunction
augroup windowtitle
  autocmd!
  autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call UpdateTitle()
augroup END

" Alias some terminal colors for vim use.
let s:white     = "15"
let s:light     = "7"

if (&t_Co == "256")
    let s:grey1     = "249"
    let s:grey2     = "246"
    let s:grey3     = "243"
    let s:grey4     = "240"
    let s:dark      = "238"
    let s:black     = "232"
    let s:orange    = "166"
    let s:green     = "70"
    let s:yellow    = "178"
    let s:blue      = "25"
    let s:purple    = "98"
    let s:cyan      = "37"
    let s:lime      = "76"
    let s:magenta   = "164"
    let s:attn_y    = "220"
    let s:attn_o    = "215"
    let s:attn_r    = "203"
    let s:attn_g    = "112"
else
    let s:grey1     = "8"
    let s:grey2     = "8"
    let s:grey3     = "8"
    let s:grey4     = "8"
    let s:dark      = "0"
    let s:black     = "0"
    let s:orange    = "1"
    let s:green     = "2"
    let s:yellow    = "3"
    let s:blue      = "4"
    let s:purple    = "5"
    let s:cyan      = "6"
    let s:lime      = "10"
    let s:magenta   = "13"
endif

" Build an appropriate highlight command. The "NONE" before the variables
" clears the highlight completely without reverting to default.
function s:hi(group, fg, bg, attr)
    let s:c = "highlight! " .a:group ." NONE"
    if a:fg != ""   | let s:c .= " ctermfg=" .a:fg | endif
    if a:bg != ""   | let s:c .= " ctermbg=" .a:bg | endif
    if a:attr != "" | let s:c .= " cterm=" .a:attr | endif
    exec s:c
endfunction

" Clear all known highlights and syntax.
for hl_group in getcompletion('', 'highlight')
    call s:hi(hl_group, "", "", "")
endfor
syntax enable | syntax reset

" Vim user interface highlights.
" See :highlight for a complete list and current settings.
"          name             foreground  background  attributes
call s:hi("ColorColumn",    "",         s:white,    "")
call s:hi("Normal",         s:dark,     s:light,    "")
call s:hi("Folded",         s:grey1,    "",         "")
call s:hi("FoldedColumn",   s:grey1,    "",         "")
call s:hi("LineNr",         s:grey1,    "",         "")
call s:hi("Visual",         s:white,    s:grey1,    "")
call s:hi("EndOfBuffer",    s:light,    "",         "")
call s:hi("VertSplit",      s:light,    "",         "")
call s:hi("MatchParen",     s:black,    s:attn_y,   "bold")
call s:hi("Search",         "",         "",         "reverse")
call s:hi("ErrorMsg",       s:orange,   "",         "reverse")
call s:hi("Directory",      s:blue,     "",         "")
call s:hi("MoreMsg",        s:blue,     "",         "")
call s:hi("Question",       s:blue,     "",         "")

" Syntax highlights.
"          name         foreground  background  attributes
call s:hi("Comment",    s:green,    "",         "")
call s:hi("Constant",   s:green,    "",         "")
call s:hi("Identifier", s:dark,     "",         "")
call s:hi("Statement",  s:orange,   "",         "")
call s:hi("PreProc",    s:blue,     "",         "")
call s:hi("Type",       s:dark,     "",         "")
call s:hi("Special",    s:dark,     "",         "")
call s:hi("Underlined", s:magenta,  "",         "")
call s:hi("Ignore",     s:orange,   "",         "bold,reverse")
call s:hi("Error",      s:orange,   "",         "bold")
call s:hi("Todo",       s:orange,   "",         "bold")

" Cleanup.
delfunction s:hi
