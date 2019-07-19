let nvimRoot = '~/.config/nvim'
let nvimPlugged = nvimRoot.'/plugged'
let nvimBin = nvimRoot.'/bin'

call plug#begin(nvimPlugged)
Plug '2072/PHP-Indenting-for-VIm' " PHP indents
Plug 'HerringtonDarkholme/yats.vim'
Plug 'Quramy/tsuquyomi'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'StanAngeloff/php.vim'
Plug 'airblade/vim-gitgutter' " Shows git changes in file (A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.)
Plug 'avakhov/vim-yaml'
Plug 'carlitux/deoplete-ternjs'
Plug 'cespare/vim-toml'
Plug 'cohlin/vim-colorschemes' " Dracula colortheme + airline theme, https://github.com/cohlin/vim-colorschemes
Plug 'ekalinin/Dockerfile.vim'
Plug 'hashivim/vim-terraform'
Plug 'jonathanfilip/vim-lucius' " Light colortheme
Plug 'kien/ctrlp.vim'
Plug 'leafgarland/typescript-vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'mhartington/deoplete-typescript', {'do': './install.sh'}
Plug 'mzlogin/vim-markdown-toc'
Plug 'neomake/neomake'
Plug 'pangloss/vim-javascript'
Plug 'pearofducks/ansible-vim'
Plug 'rakshazi/logstash.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter' " Cool plugin for commenting
Plug 'scrooloose/nerdtree' " File tree
Plug 'scrooloose/syntastic' " Linter (syntax checker)
Plug 'ternjs/tern_for_vim'
Plug 'tpope/vim-sensible' " 'Base' vim config
Plug 'vim-airline/vim-airline' " You know what is it
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-php/tagbar-phpctags.vim'
call plug#end()
autocmd VimEnter * call deoplete#custom#source('_',  'disabled_syntaxes', ['Comment', 'String'])

" Keymap
"" Toggle comment
map <C-_> <plug>NERDCommenterToggle
imap <C-_> <c-o><C-_>

"" Tagbar
nnoremap <F8> :TagbarToggle<CR>

"" Map buffers
nnoremap <silent> <C-n> :call ChangeBuf(":bn")<CR>
nnoremap <silent> <C-o> :call ChangeBuf(":bp")<CR>
map <silent> <C-w> :call ChangeBuf(":bd")<CR>
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

" mardown-toc
let g:vmt_cycle_list_item_markers = 1

" autocomplection
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#max_abbr_width = 0
let g:deoplete#max_menu_width = 0
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#manual_complete()
"call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])

"" js autocomplete
let g:tern_request_timeout = 1
let g:tern_request_timeout = 6000
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]
let g:deoplete#sources#tss#javascript_support = 1
let g:tsuquyomi_javascript_support = 1
let g:tsuquyomi_auto_open = 1
let g:tsuquyomi_disable_quickfix = 1
let g:node_host_prog = '~/.nvm/versions/node/v10.16.0/bin/neovim-node-host'
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2

" ctags
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_phpctags_bin=nvimBin.'/phpctags'
let g:tagbar_phpctags_memory_limit = '512M'
let g:tagbar_type_css = {
            \ 'ctagstype' : 'Css',
            \ 'kinds'     : [
            \ 'c:classes',
            \ 's:selectors',
            \ 'i:identities'
            \ ]
            \ }
function! TagbarStatusFunc(current, sort, fname, flags, ...) abort
    let colour = a:current ? '%#StatusLine#' : '%#StatusLineNC#'
    let flagstr = join(flags, '')
    if flagstr != ''
        let flagstr = '[' . flagstr . '] '
    endif
    return colour . '[' . sort . '] ' . flagstr . fname
endfunction
let g:tagbar_status_func = 'TagbarStatusFunc'

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

" neomake
let g:neomake_javascript_enabled_makers = ['eslint']
call neomake#configure#automake('w')
let g:neomake_open_list = 2
let g:neomake_warning_sign = {
            \ 'text': '?',
            \ 'texthl': 'WarningMsg',
            \ }

let g:neomake_error_sign = {
            \ 'text': 'X',
            \ 'texthl': 'ErrorMsg',
            \ }

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/app/cache/*,*.so,*.swp,*.zip,*.lock

" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif " Start NERDTree on vim startup if no files specified in args
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " Close vim if only NERDTree buffer is opened
let NERDTreeAutoDeleteBuffer = 1 " Autoupdate buffer after file renaming
let NERDTreeShowHidden = 1 " Show hidden files

" ansible-vim
let g:ansible_extra_keywords_highlight = 1
let g:ansible_unindent_after_newline = 1
let g:ansible_extra_syntaxes = "sh.vim"
let g:ansible_attribute_highlight = "ao"
let g:ansible_name_highlight = 'b'

" Additional stuff
autocmd BufWritePost * silent! :%s/\s\+$//g " Remove all trailing whitespace (including empty lines)
autocmd QuickFixCmdPost *grep* cwindow
set encoding=utf8
set ruler
set cursorline
set confirm

" php.vim
function! PhpSyntaxOverride()
    hi! def link phpDocTags  phpDefine
    hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
    autocmd!
    autocmd FileType php call PhpSyntaxOverride()
augroup END

" Theme
"colorscheme py-darcula " dark
let g:lucius_style = "light"
colorscheme lucius " light

set tabstop=4 shiftwidth=4 expandtab " Set softtabs
set number " Show line numbers

" Buffers
function! ChangeBuf(cmd)
    if (&modified && &modifiable)
        execute ":w"
    endif
    execute a:cmd
endfunction
