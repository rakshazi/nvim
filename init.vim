call plug#begin('~/.vim/plugged')
    Plug 'vim-airline/vim-airline' " You know what is it
    Plug 'chrisbra/csv.vim' " Filetype plugin for CSV
    Plug 'scrooloose/syntastic' " Linter (syntax checker)
    Plug 'airblade/vim-gitgutter' " Shows git changes in file (A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.)
    Plug 'eugen0329/vim-esearch' " Cool file-search tool
    Plug 'tpope/vim-sensible' " 'Base' vim config
    Plug 'scrooloose/nerdtree' " File list
    Plug 'scrooloose/nerdcommenter' " Cool plugin for commenting
    Plug 'Xuyuanp/nerdtree-git-plugin' " Show git info (changes, etc) in file list
call plug#end()

" Keymap

"" Toggle NERDTree
map <F4> :NERDTreeToggle<CR>
imap <F4> <c-o><F4>

"" Toggle comment
map <C-_> <plug>NERDCommenterToggle
imap <C-_> <c-o><C-_>

"" Map buffers
nnoremap <silent> <C-n> :call ChangeBuf(":bn")<CR>
nnoremap <silent> <C-p> :call ChangeBuf(":bp")<CR>



" Airline: show tabs
let g:airline#extensions#tabline#enabled = 1

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif " Start NERDTree on vim startup if no files specified in args
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " Close vim if only NERDTree buffer is opened
let NERDTreeAutoDeleteBuffer = 1 " Autoupdate buffer after file renaming
let g:NERDTreeDirArrowExpandable = '➕'
let g:NERDTreeDirArrowCollapsible = '➖'



" Additional stuff

:set tabstop=4 shiftwidth=4 expandtab " Set softtabs

" Buffers
function! ChangeBuf(cmd)
    if (&modified && &modifiable)
        execute ":w"
    endif
    execute a:cmd
endfunction

