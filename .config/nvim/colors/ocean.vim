hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "ocean"

" Identifier         ctermfg    ctermbg       cterm      guifg         guibg         gui
highlight Comment    ctermfg=8                           guifg=#808080
highlight Constant   ctermfg=14                          guifg=#00ffff               gui=none
highlight Identifier ctermfg=6                           guifg=#00c0c0
highlight Statement  ctermfg=3                cterm=bold guifg=#c0c000               gui=bold
highlight PreProc    ctermfg=10                          guifg=#00ff00
highlight Type       ctermfg=5                cterm=bold guifg=#00c000
highlight Special    ctermfg=12               cterm=bold guifg=#0000ff
highlight Error                 ctermbg=9     cterm=bold               guibg=#ff0000
highlight Todo       ctermfg=4  ctermbg=3     cterm=bold guifg=#000080 guibg=#c0c000
highlight Directory  ctermfg=2                           guifg=#00c000
highlight Normal                                         guifg=#ffffff guibg=#000000
highlight Search     ctermbg=3                           guibg=#c0c000

hi EndOfBuffer       ctermfg=0
hi NonText           ctermfg=0
hi LineNr            ctermfg=8
hi CursorLineNr      ctermfg=15 ctermbg=none  cterm=bold
hi CursorLine                   ctermbg=0     cterm=none
hi CursorColumn                 ctermbg=0
hi VertSplit         ctermfg=0  ctermbg=none  cterm=none
hi StatuslineColor   ctermfg=15 ctermbg=0
hi StatuslineMode    ctermfg=0  ctermbg=15
hi TabLine           ctermfg=15 ctermbg=0     cterm=none
hi TabLineFill       ctermfg=0
hi TabLineSel        ctermfg=0  ctermbg=15    cterm=none
hi Title             ctermfg=8  ctermbg=none  cterm=bold
hi MatchParen        ctermfg=0  ctermbg=3     cterm=none
hi SignColumn        ctermfg=8  ctermbg=none  cterm=bold
hi DiffAdd           ctermfg=8  ctermbg=none  cterm=bold
hi DiffChange        ctermfg=8  ctermbg=none  cterm=bold
hi DiffDelete        ctermfg=8  ctermbg=none  cterm=bold
hi DiffText          ctermfg=0  ctermbg=3     cterm=none
hi Pmenu             ctermfg=15 ctermbg=0     cterm=none
hi PmenuSel          ctermfg=0  ctermbg=15    cterm=none
hi PmenuSbar         ctermfg=8  ctermbg=8
hi Conceal           ctermfg=0  ctermbg=none
hi CocErrorSign      ctermfg=1                cterm=bold
hi CocWarningSign    ctermfg=3                cterm=bold
hi CocInfoSign       ctermfg=4                cterm=bold
hi CocHintSign       ctermfg=6                cterm=bold
