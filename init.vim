let nvimRoot = '~/.config/nvim'
let nvimPlugged = nvimRoot.'/plugged'
let nvimBin = nvimRoot.'/bin'

call plug#begin(nvimPlugged)
    Plug 'vim-airline/vim-airline' " You know what is it
    Plug 'vim-airline/vim-airline-themes'
    Plug 'scrooloose/syntastic' " Linter (syntax checker)
    Plug 'scrooloose/nerdtree' " File tree
    Plug 'airblade/vim-gitgutter' " Shows git changes in file (A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.)
    Plug 'tpope/vim-sensible' " 'Base' vim config
    Plug 'scrooloose/nerdcommenter' " Cool plugin for commenting
    Plug '2072/PHP-Indenting-for-VIm' " PHP indents
    Plug 'stephpy/vim-php-cs-fixer', {'do': 'mkdir -p '.nvimBin.' && wget http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -O '.nvimBin.'/php-cs-fixer.phar && chmod a+x '.nvimBin.'/php-cs-fixer.phar'} " PHP CS
    Plug 'cohlin/vim-colorschemes' " Dracula colortheme + airline theme, https://github.com/cohlin/vim-colorschemes
    Plug 'jonathanfilip/vim-lucius' " Light colortheme
    Plug 'pearofducks/ansible-vim'
call plug#end()

" Keymap
"" Toggle comment
map <C-_> <plug>NERDCommenterToggle
imap <C-_> <c-o><C-_>

"" Map buffers
nnoremap <silent> <C-n> :call ChangeBuf(":bn")<CR> " Next buffer on Ctrl+n
nnoremap <silent> <C-p> :call ChangeBuf(":bp")<CR> " Previous buffer on Ctrl+p
map <silent> <C-w> :call ChangeBuf(":bd")<CR> " Close current buffer on Ctrl+w
imap <C-w> <c-o><C-w>

"" Toggle nerdtree
map <silent> <F4> :NERDTreeToggle<CR>
imap <silent> <F4> <c-o><F4>

"" QuickFix windows navigation (eg: for :grep)
map <silent> <C-Down> :cn<CR>
map <silent> <C-Up> :cp<CR>

"" Off search highlight on ESC
map <silent> <ESC> :nohlsearch<CR>

"" Save buffer on Ctrl+s
map <silent> <C-s> :w<CR>
imap <C-s> <c-o><C-s>

" Airline
set laststatus=2
let g:airline_theme = "bubblegum" " Theme
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1 " Show tabs
let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n' : 'N',
      \ 'i' : 'I',
      \ 'R' : 'R',
      \ 'c' : 'C',
      \ 'v' : 'V',
      \ 'V' : 'V',
      \ '^V' : 'V',
      \ 's' : 'S',
      \ 'S' : 'S',
      \ '^S' : 'S',
      \ }

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif " Start NERDTree on vim startup if no files specified in args
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " Close vim if only NERDTree buffer is opened
let NERDTreeAutoDeleteBuffer = 1 " Autoupdate buffer after file renaming
let NERDTreeShowHidden = 1 " Show hidden files

" vim-php-cs-fixer
let g:php_cs_fixer_path = nvimBin."/php-cs-fixer.phar"
let g:php_cs_fixer_level = "psr2"
let g:php_cs_fixer_enable_default_mapping = 0
autocmd BufWritePost *.php silent! :call PhpCsFixerFixFile()  | silent! :syntax on " Auto fix php file on save

" ansible-vim
let g:ansible_extra_keywords_highlight = 1
let g:ansible_unindent_after_newline = 1
let g:ansible_extra_syntaxes = "sh.vim"
let g:ansible_attribute_highlight = "ao"
let g:ansible_name_highlight = 'b'
autocmd BufRead,BufNewFile deploy.yml set ft=ansible

" Additional stuff
autocmd BufWritePost * silent! :%s/\s\+$//g " Remove all trailing whitespace (including empty lines)
autocmd QuickFixCmdPost *grep* cwindow
set encoding=utf8
set ruler
set cursorline
set confirm
set guifont=Ubuntu\ Mono\ derivative\ Nerd\ Font\ 13

" Theme
" colorscheme py-darcula " dark
let g:lucius_style = "light"
colorscheme lucius " light

set tabstop=4 shiftwidth=4 expandtab " Set softtabs
set number " Show line numbers
if has("gui_running")
    set mouse=a
else
    set mouse=
endif

" Buffers
function! ChangeBuf(cmd)
    if (&modified && &modifiable)
        execute ":w"
    endif
    execute a:cmd
endfunction
