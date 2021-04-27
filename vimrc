ca vconf new ~/.vimrc           " Quick edit this file with :vconf
ca rev source ~/.vimrc          " Quick reload this file with :rev

set noeb vb t_vb=               " STFU: No terminal blinking
set t_Co=256                    " Tmux workaround: Force 256-color terminal
set bg=dark                     " Tmux workaround: Force dark mode
set ttymouse=xterm2 mouse=a     " Tmux workaround: Enable mouse

set wrapmargin=0 nowrap         " Turn off automatic line wrap
set textwidth=78                " Width when reflowing text (e.g. `gq`)
set autoindent smartindent      " Automatic syntax-aware indentation (C style)
set undofile                    " Persistent unlimited undo

set expandtab                   " Tabs: Always use spaces instead of '\t'
set tabstop=4 shiftwidth=4      " Tabs: Use 4 spaces for tab
set softtabstop=4               " Tabs: Backspace erases 4 spaces at a time

set incsearch hlsearch          " Search: Continuously highlight searches
set ignorecase smartcase        " Search: Ignore case, for small letters only
nn  <C-c> :noh<CR>:<C-c>        " Search: Ctrl-C discards current highlights

set noequalalways               " UI: Don't equalize window sizes
set winheight=99 helpheight=99  " UI: Maximize new windows

set numberwidth=5               " UI: Fixed line number width up to 9999 lines
au  BufEnter * set number       " UI: Line numbers everywhere, including help
let &cc=join(range(1,78),",")   " UI: Highlight 78 columns (see ColorColumn)

set laststatus=2                " UI: Enable statusline always
set statusline=%33.33(%)        " UI: Statusline left-aligned padding
set statusline+=%50.50(%f%)     " UI: Statusline right-aligned file name
set t_ts=]2; t_fs=\\ title  " UI: Enable window title

""" Update the window title with the compact file name when changing buffers
au BufEnter * let &titlestring="vim " . expand("%:~")



""" Do some work to make highlight and color configuration more painless:

""" First create a function for composing a `highlight` vim command from the
""" supplied parameters. The leading "NONE" clears the target highlight
""" group's colors without reverting to built-in defaults.
func s:hl(group, fg, bg, attr)
    let s:com = "hi! " . a:group . " NONE"
    if   a:fg   != "" | let s:com .= " ctermfg=" . a:fg   | endif
    if   a:bg   != "" | let s:com .= " ctermbg=" . a:bg   | endif
    if   a:attr != "" | let s:com .= " cterm="   . a:attr | endif
    exec s:com
endf

""" Then we can easily clear all predefined highlights.
for w in getcompletion("", "highlight") | call s:hl(w, "", "", "") | endfor

""" After that, we pull in highlights from filetype-specific syntaxes.
syntax enable

""" Now we can configure custom highlights in a terse and readable manner:
"""
""" UI highlights           foreground  background  styles
""" ===============================================================
call s:hl("ColorColumn",    "",         "233",      "")
" call s:hl("Normal",       "",         "",         "")
" call s:hl("Folded",       "",         "",         "")
" call s:hl("FoldedColumn", "",         "",         "")
" call s:hl("FoldColumn",   "",         "",         "")
call s:hl("LineNr",         "darkgrey", "",         "")
call s:hl("Visual",         "",         "darkgrey", "")
call s:hl("EndOfBuffer",    "black",    "",         "")
call s:hl("StatusLine",     "cyan",     "",         "")
call s:hl("StatusLineNC",   "darkgrey", "",         "")
" call s:hl("VertSplit",    "",         "",         "")
call s:hl("MatchParen",     "green",    "",         "underline")
call s:hl("Search",         "green",    "",         "underline")
" call s:hl("ErrorMsg",     "",         "",         "")
" call s:hl("Directory",    "",         "",         "")
" call s:hl("MoreMsg",      "",         "",         "")
" call s:hl("Question",     "",         "",         "")

""" The root syntax higlight groups are `Comment`, `Constant`, `Error`,
""" `Identifier`, `Statement`, `PreProc`, `Type`, `Special`, `Underlined`,
""" `Ignore` and  `Todo`.
"""
""" Syntax highlights       foreground  background  styles
""" ===============================================================
call s:hl("Todo",           "red",      "",         "")
