ca vconf new ~/.vimrc           " Quick edit this file with `:vconf`
ca rev source ~/.vimrc          " Quick reload this file with `:rev`

set noeb vb t_vb=               " STFU: No terminal flashing
set t_Co=256                    " Tmux workaround: Force 256-color terminal
set bg=dark                     " Tmux workaround: Force dark mode
set ttymouse=xterm2 mouse=a     " Tmux workaround: Enable mouse

" Override ftplugin textwidths
au BufWinEnter * let &textwidth=80

set formatoptions+=cn           " Autowrap comments and autorenumber lists
set autoindent smartindent      " Automatic syntax-aware indentation (C style)
set undofile                    " Persistent unlimited undo

set expandtab smarttab          " Tabs: Always use spaces instead of tabs
set tabstop=4 shiftwidth=4      " Tabs: Use 4 spaces for tab

""" Spacebar unhighlights search hits
nn <silent> <Space> :noh<CR>

set incsearch hlsearch          " Search: Continuously highlight searches
set ignorecase smartcase        " Search: Ignore case, for small letters only

""" Basic bracket matching when typing
inoremap {<CR> {<CR>}<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap (<CR> (<CR>)<Esc>O

set noequalalways               " Rolodex mode: Don't equalize window sizes
set winheight=99 helpheight=99  " Rolodex mode: Maximize new windows
let &cc=join(range(1,80),",")   " UI: Colorcolumn text width indicator

set laststatus=2                " UI: Enable statusline always
set statusline=%30.30(%)        " UI: Statusline left-aligned padding
set statusline+=%50.50(%f%)     " UI: Statusline right-aligned file name



""" Do some work to make highlight style and color configuration less painful:

""" A function for composing vim `highlight` commands. The leading "NONE" clears
""" previous colors without reverting to default.
func s:hl(group, fg, bg, attr)
    let s:com = "hi! " . a:group . " NONE"
    if   a:fg   != "" | let s:com .= " ctermfg=" . a:fg   | endif
    if   a:bg   != "" | let s:com .= " ctermbg=" . a:bg   | endif
    if   a:attr != "" | let s:com .= " cterm="   . a:attr | endif
    exec s:com
endf

""" Clear all predefined highlights.
for h in getcompletion("", "highlight") | call s:hl(h, "", "", "") | endfor

""" Enable filetype-specific settings and syntax highlighting.
filetype plugin on
syntax enable

""" Run `:highlight` for a complete list of User Interface highlight groups.
""" Some important groups:
"""
""" UI highlight group      Foreground  Background  Styles
call s:hl("Normal",         "",         "",         "")
call s:hl("ColorColumn",    "",         "233",      "")
call s:hl("LineNr",         "darkgrey", "",         "")
call s:hl("Visual",         "",         "darkgrey", "")
call s:hl("EndOfBuffer",    "black",    "",         "")
call s:hl("StatusLine",     "cyan",     "",         "")
call s:hl("StatusLineNC",   "darkgrey", "",         "")
call s:hl("MatchParen",     "green",    "",         "underline")
call s:hl("Search",         "green",    "",         "underline")
call s:hl("ErrorMsg",       "red",      "",         "")

""" Base syntax groups: `Comment`, `Constant`, `Error`, `Identifier`,
""" `Statement`, `PreProc`, `Type`, `Special`, `Underlined`, `Ignore`, `Todo`.
"""
""" Syntax highlight group  Foreground  Background  Styles
call s:hl("Todo",           "red",      "",         "")
