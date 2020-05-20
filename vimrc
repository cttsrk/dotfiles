set nocompatible | " Don't care to be compatible with vi circa 1976.

" Quickly edit and reload this file from anywhere.
cabbrev vimcon vert new ~/.vimrc
cabbrev rev source ~/.vimrc

set undofile | " Save unlimited per-file undo trees in appdata.
set lazyredraw
set mouse=a
set noeb vb t_vb=
set laststatus=0
set noruler
set hidden
set scrolloff=3
set splitright splitbelow
set foldcolumn=0 number numberwidth=5
let &colorcolumn="".join(range(1,80),",")
syntax enable

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
    inoremap <Char-0x07F> <BS>
    nnoremap <Char-0x07F> <BS>
endif

"Trigger InsertLeave event when exiting insert mode with Control-C
inoremap <C-c> <Esc>

" Usec Control-C to dehighlight searches. The extra : makes vim shut up about
" the command we ran and about how to exit vim.
nnoremap <C-c> :nohlsearch<CR>:<C-c>

" Unbind some keys that encourage suboptimal use patterns like straying from
" the home row or navigating by line. (Don't use bar to compact this section.)
" Normal mode etc:
noremap <Home> <Nop>
noremap <End> <Nop>
noremap <Insert> <Nop>
noremap <BS> <Nop>
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
noremap h <Nop>
noremap j <Nop>
noremap k <Nop>
noremap l <Nop>
" Insert and Command mode:
noremap! <Home> <Nop>
noremap! <End> <Nop>
noremap! <Insert> <Nop>
noremap! <BS> <Nop>
noremap! <Up> <Nop>
noremap! <Down> <Nop>
noremap! <Left> <Nop>
noremap! <Right> <Nop>

" Set the title to "filename" in tmux or screen or a terminal emulator.
function! UpdateTitle()
  let &titlestring="".fnamemodify(expand("%"),":~")
  set title
endfunction
augroup windowtitle
  autocmd!
  autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call UpdateTitle()
augroup END


" VIM THEME SETTINGS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Does not define colors, only UI elements.
" This highlight scheme does not define any colors. It uses the already defined
" terminal colors, and only decides which parts of the Vim user interface
" inherit which color category.
" 
" The terminal colors are set for us by "~/.color_terminal" at shell init, all
" we have to do is use them. Any 16 color terminal should work for us, but
" it'll look nicer if "~/.color_terminal" knows how to modify the 16 ansi
" colors of that terminal.

highlight clear
syntax reset

" These are Base16 base00 through base07, the "grey" scale. In a dark
" theme, they go from 0 darkest to 7 lightest, and vice versa in a light theme.
let s:bg1   = "0"
let s:bg2   = "4"
let s:cont1 = "8"
let s:cont2 = "9"
let s:cont3 = "14"
let s:cont4 = "11"
let s:hi1   = "7"
let s:hi2   = "15"

" Colors 1 through 6 are always available, 16 and 17 are Base16 extras. The
" naming correspond to "Tomorrow Night". In "Solarized", purple is magenta and
" magenta is violet.
let s:orange = "1"
let s:green  = "2"
let s:yellow = "3"
let s:blue   = "12"
let s:purple = "13"
let s:cyan   = "6"
let s:lime   = "10"
let s:magenta  = "5"

" Build an appropriate highlight command and run it. The "NONE" before the
" variables clears the highlight completely without reverting to default, so
" there's no need to further override defaults below.
function s:hi(group, fg, bg, attr)
  let s:c = "highlight! " .a:group ." NONE"
  if a:fg != ""   | let s:c .= " ctermfg=" .a:fg | endif
  if a:bg != ""   | let s:c .= " ctermbg=" .a:bg | endif
  if a:attr != "" | let s:c .= " cterm=" .a:attr | endif
  exec s:c
endfunction



" User highlights, used for the status bar.
"          name             foreground  background  attributes
call s:hi("User1",          s:cont2,     "",         "")
"call s:hi("User2",          "",         "",         "")
"call s:hi("User3",          "",         "",         "")
"call s:hi("User4",          "",         "",         "")
"call s:hi("User5",          "",         "",         "")
"call s:hi("User6",          "",         "",         "")
"call s:hi("User7",          "",         "",         "")
"call s:hi("User8",          "",         "",         "")
"call s:hi("User9",          "",         "",         "")


" Major vim user interface highlights.
"          name             foreground  background  attributes
call s:hi("ColorColumn",    "",         s:bg2,    "")
call s:hi("Cursor",         s:bg2,    s:cont3,    "")
call s:hi("lCursor",        s:bg2,    s:cont3,    "")
call s:hi("CursorLineNr",   s:green,    s:bg1,    "")
call s:hi("FoldColumn",     s:blue,     s:bg1,    "")
call s:hi("Folded",         s:cont1,    s:bg1,    "underline")
call s:hi("EndOfBuffer",    s:bg1,    s:bg1,    "")
call s:hi("LineNr",         s:cont1,    s:bg1,    "")
call s:hi("MatchParen",     s:hi2,    s:bg1,    "bold")
call s:hi("Normal",         s:cont4,    s:bg1,    "")
call s:hi("Search",         s:yellow,   s:bg1,    "reverse")
call s:hi("StatusLine",     s:cont4,    s:bg1,    "")
call s:hi("StatusLineNC",   s:cont1,    s:bg1,    "")
call s:hi("VertSplit",      s:bg1,    s:bg1,    "")
call s:hi("Visual",         s:cont1,    s:bg2,    "bold,reverse")
call s:hi("VisualNOS",      "",         s:bg1,    "bold,reverse")

" Minor vim user interface highlights.
"          name             foreground  background  attributes
call s:hi("Conceal",        s:blue,     "",    "")
call s:hi("CursorColumn",   "",         s:bg1,    "")
call s:hi("CursorLine",     "",         "",         "underline")
call s:hi("Directory",      s:blue,     "",         "")
call s:hi("DiffAdd",        s:green,    s:bg1,    "")
call s:hi("DiffChange",     s:yellow,   s:bg1,    "")
call s:hi("DiffDelete",     s:orange,      s:bg1,    "")
call s:hi("DiffText",       s:blue,     s:bg1,    "")
call s:hi("ErrorMsg",       s:orange,      "",         "reverse")
call s:hi("IncSearch",      s:orange,   "",         "reverse")
call s:hi("ModeMsg",        s:blue,     "",         "")
call s:hi("MoreMsg",        s:blue,     "",         "")
call s:hi("NonText",        s:purple,   "",         "bold")
call s:hi("Pmenu",          s:cont3,    s:bg1,    "bold,reverse")
call s:hi("PmenuSel",       s:cont1,    s:hi1,    "bold,reverse")
call s:hi("PmenuSbar",      s:hi1,    s:cont3,    "bold,reverse")
call s:hi("PmenuThumb",     s:cont3,    s:bg2,    "bold,reverse")
call s:hi("Question",       s:cyan,     "",         "bold")
call s:hi("SignColumn",     "",         s:bg1,    "")
call s:hi("SpecialKey",     s:purple,   "",         "bold")
call s:hi("SpellBad",       "",         "",         "undercurl")
call s:hi("SpellCap",       "",         "",         "undercurl")
call s:hi("SpellLocal",     "",         "",         "undercurl")
call s:hi("SpellRare",      "",         "",         "undercurl")
call s:hi("TabLine",        s:cont3,    s:bg1,    "reverse")
call s:hi("TabLineFill",    s:cont3,    s:bg1,    "reverse")
call s:hi("TabLineSel",     s:cont1,    s:hi1,    "bold,reverse,underline")
call s:hi("Title",          s:orange,   "",         "bold")
call s:hi("WarningMsg",     s:orange,      "",         "bold")
call s:hi("WildMenu",       s:hi1,    s:bg1,    "bold,reverse")
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
call s:hi("Error",          s:orange,      s:bg1,    "bold")
call s:hi("Identifier",     s:cont4,     "",         "none")
hi! link Function   Identifier
call s:hi("PreProc",        s:lime,     "",         "")
hi! link Define     PreProc
hi! link Include    PreProc
hi! link Macro      PreProc
hi! link PreCondit  PreProc
call s:hi("Special",        s:orange,      "",         "")
hi! link Debug          Special
hi! link Delimiter      Special
hi! link SpecialChar    Special
hi! link SpecialComment Special
hi! link Tag            Special
call s:hi("Statement",      s:hi1,   "",         "")
hi! link Conditional  Statement
hi! link Exception    Statement
hi! link Keyword      Statement
hi! link Label        Statement
hi! link Operator     Statement
hi! link Repeat       Statement
call s:hi("Todo",           s:orange,   s:bg1,    "bold")
call s:hi("Type",           s:blue,   "",         "")
hi! link StorageClass Type
hi! link Structure    Type
hi! link TypeDef      Type
call s:hi("Underlined",     s:magenta,    "",         "")



" Vim file Highlighting
hi! link vimFunc      Function
hi! link vimUserFunc  Function
hi! link vimVar       Identifier
hi! link vimSet       Normal
hi! link vimSetEqual  Normal
hi! link helpSpecial  Special
"          name                 foreground  background  attributes
call s:hi("helpExample",        s:cont4,    "",         "")
call s:hi("helpHyperTextEntry", s:green,    "",         "")
call s:hi("helpHyperTextJump",  s:blue,     "",         "underline")
call s:hi("helpNote",           s:blue,   "",         "")
call s:hi("helpOption",         s:cyan,     "",         "")
call s:hi("helpVim",            s:blue,   "",         "")
call s:hi("vimCmdSep",          s:blue,     "",         "bold")
call s:hi("vimCommand",         s:cont4,    "",         "")
call s:hi("vimCommentString",   s:blue,    "",         "")
call s:hi("vimGroup",           s:blue,     "",         "bold,underline" )
call s:hi("vimHiGroup",         s:blue,     "",         "")
call s:hi("vimHiLink",          s:blue,     "",         "")
call s:hi("vimIsCommand",       s:cont2,    "",         "")
call s:hi("vimSet",             s:cont3,    "",         "")
call s:hi("vimSetEqual",        s:cont3,    "",         "")
call s:hi("vimSynMtchOpt",      s:yellow,   "",         "")
call s:hi("vimSynType",         s:cyan,     "",         "")

" Cleanup.
delfunction s:hi
