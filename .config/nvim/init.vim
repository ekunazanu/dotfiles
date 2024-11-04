colo ocean
set notgc
set nu rnu
set so=5
set ch=5
set ts=4
set sw=4
set scl=yes:1
set nosmd
set cul
set et
set nofixeol
set cb=unnamedplus
" set sts=0
" set noet
" set lcs=tab:\┊\ 
" set list

au BufEnter,InsertLeave * set rnu | hi StatuslineMode ctermfg=0 ctermbg=15
au BufLeave,InsertEnter * set nornu | hi StatuslineMode ctermfg=0 ctermbg=1

" tree
" let g:netrw_banner = 0
" let g:netrw_browse_split = 3
" let g:netrw_winsize = 10
" let g:netrw_liststyle = 3
" let g:netrw_altv = 1
" au VimEnter * :Vex

" mode
let g:currentmode={
    \ 'n'      : 'N',
    \ 'i'      : 'I',
    \ 'R'      : 'R',
    \ 'c'      : 'C',
    \ 'v'      : 'V',
    \ 's'      : 'S',
    \ 't'      : 'T',
    \ 'ce'     : 'E',
    \ 'cv'     : 'VE',
    \ 'V'      : 'V Line',
    \ '\<C-V>' : 'V Block',
    \ 'S'      : 'S Line',
    \ '\<C-S>' : 'S Block',
    \ 'Rv'     : 'V Replace',
    \ 'no'     : 'Pending',
    \ 'r'      : 'Prompt',
    \ 'rm'     : 'More',
    \ 'r?'     : 'Confirm',
    \ '!'      : 'Shell'
    \}

" statusline
set ls=2
set stl=
set stl+=%#StatuslineMode#
set stl+=\ %{toupper(g:currentmode[mode()])}\ 
set stl+=%#StatuslineColor#
set stl+=\ %.20f
set stl+=\ %m
set stl+=%=
set stl+=\ %y
set stl+=\ %{&fileencoding?&fileencoding:&encoding}
set stl+=\[%{&fileformat}\]
set stl+=\ %3p%%\ 
set stl+=%#StatuslineMode#
set stl+=\ %3l:%-3c

" tabline
set stal=2
set tpm=10

" mappings
" ino " ""<left>
" ino ' ''<left>
" ino ( ()<left>
" ino [ []<left>
" ino { {}<left>
imap <buffer> <C-BS> <C-W>
map <buffer> <F6> :w<CR>:term gcc -Werror %:p:S -o %:p:r:S && %:p:r:S<CR>i
imap <buffer> <F6> <Esc>:w<CR>:term gcc -Werror %:p:S -o %:p:r:S && %:p:r:S<CR>i
map <buffer> <F7> :w<CR>:term chicken-csc %:p:S -o %:p:r:S && %:p:r:S<CR>i
imap <buffer> <F7> <Esc>:w<CR>:term chicken-csc %:p:S -o %:p:r:S && %:p:r:S<CR>i
map <buffer> <F8> :w<CR>:term javac %:p:S && java -cp %:p:h %:t:r<CR>i
imap <buffer> <F8> <Esc>:w<CR>:term javac %:p:S && java -cp %:p:h %:t:r<CR>i
map <buffer> <F9> :w<CR>:term %:p:S<CR>i
imap <buffer> <F9> <Esc>:w<CR>:term %:p:S<CR>i

" set <xUp>=\e[1;*A
" set <xDown>=\e[1;*B
" set <xRight>=\e[1;*C
" set <xLeft>=\e[1;*D

" plugins
" call plug#begin()
" Plug 'yggdroot/indentline'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" call plug#end()

" let g:indentLine_char = '┊'
" let g:indentLine_setColors = 0

" todo
" tabline
" tree
