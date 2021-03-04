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
Plug 'cespare/vim-toml'
Plug 'cohlin/vim-colorschemes' " Dracula colortheme + airline theme, https://github.com/cohlin/vim-colorschemes
Plug 'deoplete-plugins/deoplete-tag'
Plug 'ekalinin/Dockerfile.vim'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'hashivim/vim-terraform'
Plug 'jonathanfilip/vim-lucius' " Light colortheme
Plug 'kristijanhusak/deoplete-phpactor'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'mzlogin/vim-markdown-toc'
Plug 'noahfrederick/vim-composer'
Plug 'pearofducks/ansible-vim'
Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
Plug 'rakshazi/logstash.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter' " Cool plugin for commenting
Plug 'scrooloose/nerdtree' " File tree
Plug 'scrooloose/syntastic' " Linter (syntax checker)
Plug 'tpope/vim-sensible' " 'Base' vim config
Plug 'vim-airline/vim-airline' " You know what is it
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" Keymap
"" Toggle comment
map <C-_> <plug>NERDCommenterToggle
imap <C-_> <c-o><C-_>

"" Tagbar
nnoremap <F8> :TagbarToggle<CR>

"" Map buffers
nnoremap <silent> <C-n> :call ChangeBuf(":bn")<CR>
nnoremap <silent> <C-p> :call ChangeBuf(":bp")<CR>
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
set completeopt-=preview
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('ignore_case', 1)
call deoplete#custom#option('smart_case', 1)
call deoplete#custom#option('camel_case', 1)
call deoplete#custom#option('refresh_always', 1)
call deoplete#custom#option('max_abbr_width', 0)
call deoplete#custom#option('max_menu_width', 0)
call deoplete#custom#option('ignore_sources', {'php': ['omni']})
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
call deoplete#custom#source('_',  'disabled_syntaxes', ['Comment', 'String'])
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#manual_complete()

" ctags
let g:gutentags_enabled = 1
let g:gutentags_resolve_symlinks = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
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

" vim-go https://github.com/fatih/vim-go-tutorial
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#test#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction

let g:go_list_type = "quickfix"
let g:go_echo_go_info = 0
let g:go_doc_popup_window = 1
let g:go_gopls_enabled = 1
let g:go_metalinter_autosave = 1
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_function_calls = 1
autocmd FileType go nmap <C-b> :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <C-r>  <Plug>(go-run)
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4 nolist

" Additional stuff
autocmd BufWritePre * kz|:%s/\s\+$//e|'z
" autocmd BufWritePost * silent! :%s/\s\+$//g " Remove all trailing whitespace (including empty lines)
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
colorscheme py-darcula " dark
" let g:lucius_style = "light"
" colorscheme lucius " light

set tabstop=4 shiftwidth=4 expandtab " Set softtabs
set number " Show line numbers

" Buffers
function! ChangeBuf(cmd)
    if (&modified && &modifiable)
        execute ":w"
    endif
    execute a:cmd
endfunction
