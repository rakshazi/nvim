let nvimRoot = '~/.config/nvim'
let nvimPlugged = nvimRoot.'/plugged'
let nvimBin = nvimRoot.'/bin'

call plug#begin(nvimPlugged)
    Plug 'vim-airline/vim-airline' " You know what is it
    Plug 'scrooloose/syntastic' " Linter (syntax checker)
    Plug 'airblade/vim-gitgutter' " Shows git changes in file (A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.)
    Plug 'tpope/vim-sensible' " 'Base' vim config
    Plug 'scrooloose/nerdtree' " File list
    Plug 'scrooloose/nerdcommenter' " Cool plugin for commenting
    Plug 'Xuyuanp/nerdtree-git-plugin' " Show git info (changes, etc) in file list
    Plug '2072/PHP-Indenting-for-VIm' " PHP indents
    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-easytags'
    Plug 'stephpy/vim-php-cs-fixer', {'do': 'mkdir -p '.nvimBin.' && wget http://get.sensiolabs.org/php-cs-fixer.phar -O '.nvimBin.'/php-cs-fixer.phar && chmod a+x '.nvimBin.'/php-cs-fixer.phar'} " PHP CS
    Plug 'shawncplus/phpcomplete.vim'
    Plug 'vim-php/phpctags', {'do': 'mkdir -p '.nvimBin.' && wget http://vim-php.com/phpctags/install/phpctags.phar -O '.nvimBin.'/phpctags.phar && chmod a+x '.nvimBin.'/phpctags.phar'}
    Plug 'cohlin/vim-colorschemes' " Dracula colortheme + airline theme, https://github.com/cohlin/vim-colorschemes
    Plug 'eshion/vim-sync' " Autoupload changed files
    Plug 'mjoey/vim-magento' " Magento helper commands
call plug#end()

" Keymap

"" Toggle NERDTree
map <F4> :NERDTreeToggle<CR>
imap <F4> <c-o><F4>

"" Toggle comment
map <C-_> <plug>NERDCommenterToggle
imap <C-_> <c-o><C-_>

"" Map buffers
nnoremap <silent> <C-n> :call ChangeBuf(":bn")<CR> " Next buffer on Ctrl+n
nnoremap <silent> <C-p> :call ChangeBuf(":bp")<CR> " Previous buffer on Ctrl+p
map <silent> <C-w> :call ChangeBuf(":bd")<CR> " Close current buffer on Ctrl+w
imap <C-w> <c-o><C-w>

"" File sync
nnoremap <C-u> <ESC>:call SyncUploadFile()<CR>

"" QuickFix windows navigation (eg: for :grep)
map <silent> <C-Down> :cn<CR>
map <silent> <C-Up> :cp<CR>

"" Off search highlight on ESC
map <silent> <ESC> :nohlsearch<CR>

"" Save buffer on Ctrl+s
map <silent> <C-s> :w<CR>
imap <C-s> <c-o><C-s>

"" Omnicomplete on <tab>
inoremap <tab> <c-r>=Smart_TabComplete()<CR>


" Airline
set laststatus=2
let g:airline_theme = "darcula" " Theme
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1 " Show tabs
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

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
let NERDTreeShowHidden = 1 " Show hidden files

" vim-php-cs-fixer
let g:php_cs_fixer_path = nvimBin."/php-cs-fixer.phar"
let g:php_cs_fixer_level = "psr2"
let g:php_cs_fixer_enable_default_mapping = 0
autocmd BufWritePost *.php silent! :call PhpCsFixerFixFile()  | silent! :syntax on " Auto fix php file on save

" vim-easytags
let g:easytags_cmd = nvimBin.'/phpctags.phar'
let g:easytags_file = nvimRoot.'/tags'

" vim-magento
let g:vimMagentoAuthor = "Nikita Chernyi <developer.nikus@gmail.com>"
let g:vimMagentoCopyright = " "
let g:vimMagentoLicense = " "
let g:vimMagentoSignature = 0

" phpcomplete.vim
let g:phpcomplete_parse_docblock_comments = 1 " Show docs from comments
autocmd CompleteDone * pclose " Autoclose preview windows with docs after complete done

" Additional stuff

set encoding=utf8
set guifont=Ubuntu\ Mono\ derivative\ Nerd\ Font\ 13
colorscheme py-darcula "Colortheme
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

" Use <tab> for complete only if string not empty
function! Smart_TabComplete()
  let line = getline('.')                         " current line
  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  "let has_period = match(substr, '\.') != -1      " position of period, if any
  "let has_slash = match(substr, '\/') != -1       " position of slash, if any
  "if (!has_period && !has_slash)
    "return "\<C-X>\<C-P>"                         " existing text matching
  "elseif ( has_slash )
    "return "\<C-X>\<C-F>"                         " file matching
  "else
    return "\<C-X>\<C-O>"                         " plugin matching
  "endif
endfunction
