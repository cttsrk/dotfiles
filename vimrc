set nocompatible        " Don't care to be compatible with vi circa 1976.

" Quickly edit and reload this file from anywhere.
cabbrev vconf vert new ~/.vimrc
cabbrev rev source ~/.vimrc

set undofile            " Save unlimited per-file undo trees in appdata.
set lazyredraw
set mouse=a
set noeb vb t_vb=
set laststatus=0
set noruler
set hidden
set scrolloff=3
set splitright splitbelow
set foldcolumn=0 numberwidth=5
syntax enable

augroup buffer_switch_settings
    autocmd!
    autocmd WinLeave * :set colorcolumn=0
    autocmd BufEnter * :let &colorcolumn="".join(range(1,80),",")
    autocmd BufEnter * :set number
augroup END

" Indentation settings
set tabstop=4 shiftwidth=4 expandtab autoindent

" Search settings
set ignorecase smartcase incsearch

" Don't fill the fold line with underscores.
" Don't fill the vertical split separator with pipes.
" Don't put squiggles after end-of-buffer.
set fillchars="vert: ,fold: ,eob: "

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

" Unbind keys that encourage suboptimal use patterns.
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

" Set the title to "filename" in tmux or screen or a terminal emulator.
function! UpdateTitle()
  let &titlestring="".fnamemodify(expand("%"),":~")
  set title
endfunction
augroup windowtitle
  autocmd!
  autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call UpdateTitle()
augroup END


" VIM THEME SETTINGS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" The terminal colors are set for us by the shell using "~/.dotfiles/color_terminal".
highlight clear
syntax reset

"   vim name    
let s:bg1       = "0"
let s:bg2       = "4"
let s:cont1     = "8"
let s:cont2     = "9"
let s:cont3     = "14"
let s:cont4     = "11"
let s:hi1       = "7"
let s:hi2       = "15"
let s:orange    = "1"
let s:green     = "2"
let s:yellow    = "3"
let s:blue      = "12"
let s:purple    = "13"
let s:cyan      = "6"
let s:lime      = "10"
let s:magenta   = "5"

" Build an appropriate highlight command and run it. The "NONE" before the
" variables clears the highlight completely without reverting to default.
function s:hi(group, fg, bg, attr)
  let s:c = "highlight! " .a:group ." NONE"
  if a:fg != ""   | let s:c .= " ctermfg=" .a:fg | endif
  if a:bg != ""   | let s:c .= " ctermbg=" .a:bg | endif
  if a:attr != "" | let s:c .= " cterm=" .a:attr | endif
  exec s:c
endfunction

" Major vim user interface highlights.
"          name             foreground  background  attributes
call s:hi("User1",          s:cont2,    "",         "")
call s:hi("ColorColumn",    "",         s:bg2,      "")
call s:hi("Cursor",         s:bg2,      s:cont3,    "")
call s:hi("lCursor",        s:bg2,      s:cont3,    "")
call s:hi("CursorLineNr",   s:green,    s:bg1,      "")
call s:hi("FoldColumn",     s:blue,     s:bg1,      "")
call s:hi("Folded",         s:cont1,    s:bg1,      "underline")
call s:hi("EndOfBuffer",    s:bg1,      s:bg1,      "")
call s:hi("LineNr",         s:cont1,    s:bg1,      "")
call s:hi("MatchParen",     s:hi2,      s:bg1,      "bold")
call s:hi("Normal",         s:cont4,    s:bg1,      "")
call s:hi("Search",         s:yellow,   s:bg1,      "reverse")
call s:hi("StatusLine",     s:cont4,    s:bg1,      "")
call s:hi("StatusLineNC",   s:cont1,    s:bg1,      "")
call s:hi("VertSplit",      s:bg1,      s:bg1,      "")
call s:hi("Visual",         s:cont1,    s:bg2,      "bold,reverse")
call s:hi("VisualNOS",      "",         s:bg1,      "bold,reverse")

" Minor vim user interface highlights.
"          name             foreground  background  attributes
call s:hi("Conceal",        s:blue,     "",         "")
call s:hi("CursorColumn",   "",         s:bg1,      "")
call s:hi("CursorLine",     "",         "",         "underline")
call s:hi("Directory",      s:blue,     "",         "")
call s:hi("DiffAdd",        s:green,    s:bg1,      "")
call s:hi("DiffChange",     s:yellow,   s:bg1,      "")
call s:hi("DiffDelete",     s:orange,   s:bg1,      "")
call s:hi("DiffText",       s:blue,     s:bg1,      "")
call s:hi("ErrorMsg",       s:orange,   "",         "reverse")
call s:hi("IncSearch",      s:orange,   "",         "reverse")
call s:hi("ModeMsg",        s:blue,     "",         "")
call s:hi("MoreMsg",        s:blue,     "",         "")
call s:hi("NonText",        s:purple,   "",         "bold")
call s:hi("Pmenu",          s:cont3,    s:bg1,      "bold,reverse")
call s:hi("PmenuSel",       s:cont1,    s:hi1,      "bold,reverse")
call s:hi("PmenuSbar",      s:hi1,      s:cont3,    "bold,reverse")
call s:hi("PmenuThumb",     s:cont3,    s:bg2,      "bold,reverse")
call s:hi("Question",       s:cyan,     "",         "bold")
call s:hi("SignColumn",     "",         s:bg1,      "")
call s:hi("SpecialKey",     s:purple,   "",         "bold")
call s:hi("SpellBad",       "",         "",         "undercurl")
call s:hi("SpellCap",       "",         "",         "undercurl")
call s:hi("SpellLocal",     "",         "",         "undercurl")
call s:hi("SpellRare",      "",         "",         "undercurl")
call s:hi("TabLine",        s:cont3,    s:bg1,      "reverse")
call s:hi("TabLineFill",    s:cont3,    s:bg1,      "reverse")
call s:hi("TabLineSel",     s:cont1,    s:hi1,      "bold,reverse,underline")
call s:hi("Title",          s:orange,   "",         "bold")
call s:hi("WarningMsg",     s:orange,   "",         "bold")
call s:hi("WildMenu",       s:hi1,      s:bg1,      "bold,reverse")
hi! link NvimInternalError ErrorMsg

" Common syntax highlights.
"          name             foreground  background  attributes
call s:hi("Comment",        s:green,    "",         "")
call s:hi("Constant",       s:cyan,     "",         "")
hi! link Boolean    Constant
hi! link Character  Constant
hi! link Float      Constant
hi! link Number     Constant
hi! link String     Constant
call s:hi("Error",          s:orange,    s:bg1,     "bold")
call s:hi("Identifier",     s:cont4,     "",        "none")
hi! link Function   Identifier
call s:hi("PreProc",        s:lime,      "",        "")
hi! link Define     PreProc
hi! link Include    PreProc
hi! link Macro      PreProc
hi! link PreCondit  PreProc
call s:hi("Special",        s:lime,      "",        "")
hi! link Debug          Special
hi! link Delimiter      Special
hi! link SpecialChar    Special
hi! link SpecialComment Special
hi! link Tag            Special
call s:hi("Statement",      s:hi1,      "",         "")
hi! link Conditional  Statement
hi! link Exception    Statement
hi! link Keyword      Statement
hi! link Label        Statement
hi! link Operator     Statement
hi! link Repeat       Statement
call s:hi("Todo",           s:orange,   s:bg1,      "bold")
call s:hi("Type",           s:blue,     "",         "")
hi! link StorageClass Type
hi! link Structure    Type
hi! link TypeDef      Type
call s:hi("Underlined",     s:magenta,  "",         "")

delfunction s:hi        " Cleanup.
