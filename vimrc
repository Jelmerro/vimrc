" Jelmerro's Vim configuration
" Configure Vim with autocompletion, keybindings, editorconfig and linting
" Suitable for Python, JavaScript, React, Vue, Bash, Docker and related files
" For updates and info go to https://github.com/Jelmerro/vimrc
" This file is released as free software via MIT, see LICENSE file for details

" General
" ignore and reset distro specific configurations
set all&
set runtimepath=~/.vim,$VIMRUNTIME
set packpath=~/.vim,$VIMRUNTIME
set nocompatible
" always use 4 spaces as the default
set tabstop=4
set shiftwidth=4
set expandtab
" show tabs and other special characters as escaped sequences
set list
set listchars=tab:⮕\ ,trail:◼,nbsp:•,extends:…,precedes:…
" highlight the current line number
set cursorline
set cursorlineopt=number
" color column for optimal line length
set colorcolumn=80
" display line numbers
set number
" enable smart auto indentation
set autoindent
set smartindent
" set the .swp and backup file location to ~/.vim/backup
call mkdir(expand('~/.vim/backup/'), 'p')
set backupdir=~/.vim/backup//
set directory=~/.vim/backup//
" reduce update time for swap
set updatetime=300
" show command suggestions at the position of the statusline
set wildmenu
" show and highlight search results when typing
set hlsearch
set incsearch
" indent wrapped lines the same as the start of the line
set breakindent
" show search numbers and shorten all file info messages
set shortmess=Toat
" highlight code snippets in markdown files
let g:markdown_fenced_languages=['bash=sh', 'css', 'html', 'json', 'js=javascript', 'ts=typescript', 'python']
" find matching tags in html/xml documents using matchit
filetype plugin on
packadd! matchit
" disable super buggy netrw
let g:loaded_netrw=1
let g:netrw_loaded_netrwPlugin=1
" show JSDoc highlight colors
let g:javascript_plugin_jsdoc=1

" Keybindings
" set leader key to space
let g:mapleader=' '
" set spelling options to sound-based suggestions and allow asian characters
nmap <silent> <leader>s :set spell!<cr>
nmap <silent> <leader>ss :set spell!<cr>
nmap <silent> <leader>se :set spelllang=cjk,en<cr>
nmap <silent> <leader>sn :set spelllang=cjk,nl<cr>
nmap <silent> <leader>sa :set spelllang=cjk,en,nl<cr>
set spellsuggest=double
set spelllang=cjk,en,nl
" exit to normal mode from terminal and other places with 'kj'
tnoremap kj <C-\><C-n>
inoremap kj <Esc>
" toggle line wrap with shift-w
set nowrap
noremap <silent> W :set wrap!<cr>
" remove visual mode escape delay
set ttimeoutlen=0
" allow backspace to remove characters while inserting
set backspace=indent,eol,start
" show the list of chained keys as they are entered
set showcmd
" maximize the current window split (undo with the default <C-w>= binding)
noremap <C-w>m <C-w>500><C-w>500+
" toggle for indent-based folding and don't apply on file open
set foldmethod=indent
set foldlevel=99
nnoremap <leader>t za
" disable search without the current search remaining active in the background
nmap <silent> \ :let @/='$4'<cr>

" Airline
" always show airline as the statusline without showing the mode a second time
set laststatus=2
set noshowmode
" only enable relevant extensions
let g:airline_extensions=['coc', 'fugitiveline', 'term', 'virtualenv']

" CoC (code suggestions, diagnostics and refactoring)
" find or update definitions
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-rename)
" autoformat code based on linter
function! s:auto_format()
    " eslint is no longer exposed as a proper linter to coc
    if index(['js', 'jsx', 'javascript', 'javascriptreact', 'ts', 'typescript', 'typescriptcommon', 'typescriptreact'], &filetype) >= 0
        silent! CocCommand eslint.executeAutofix
    else
        call CocActionAsync('format')
    endif
endfunction
noremap <silent> <leader>f :call <SID>auto_format()<cr>
" always show signcolumn to prevent flashes
set signcolumn=yes
" jump to diagnostics or the documentation
nmap <silent> <C-k> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-j> <Plug>(coc-diagnostic-next)
function! s:show_documentation()
    if index(['vim','help'], &filetype) >= 0
        execute 'h '.expand('<cword>')
    else
        call CocActionAsync('doHover')
    endif
endfunction
noremap <silent> K :call <SID>show_documentation()<cr>
" scroll popup windows
function s:find_cursor_popup(...)
  let radius = 50
  let srow = screenrow()
  let scol = screencol()
  for r in range(srow - radius, srow + radius)
    for c in range(scol - radius, scol + radius)
      let winid = popup_locate(r, c)
      if winid != 0
        return winid
      endif
    endfor
  endfor
  return 0
endfunction
function s:scroll_cursor_popup(down)
  let winid = <SID>find_cursor_popup()
  if winid == 0
    return 0
  endif
  let pp = popup_getpos(winid)
  call popup_setoptions(winid, {'firstline': pp.firstline + a:down})
  return 1
endfunction
imap <expr> <C-f> <SID>scroll_cursor_popup(1) ? '' : ''
imap <expr> <C-b> <SID>scroll_cursor_popup(-1) ? '' : ''
" expand snippets, completion or copilot with tab key based on selection
nmap <S-Tab> <<
nmap <Tab> >>
imap <silent> <S-Tab> <Nop>
let g:copilot_no_tab_map = v:true
inoremap <silent><expr> <Tab>
      \ coc#pum#has_item_selected() ? coc#_select_confirm() :
      \ exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") : ""
" automatically fix diagnostics aor refactor
noremap <silent> <leader>d :CocList diagnostics<cr>
nmap <leader>c <Plug>(coc-codeaction)
xmap <leader>c <Plug>(coc-codeaction-selected)

" FZF
" match the theme's colorscheme in the fzf windows
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
nnoremap <leader>r :Rg<cr>
nnoremap <leader>e :Files<cr>
nnoremap <leader>b :Buffers<cr>

" Instant Markdown
" disable autostart when opening a file
let g:instant_markdown_autostart=0
" Add a single startup command that also can also restart
function! s:markdown_preview()
    silent! InstantMarkdownStop
    silent! InstantMarkdownPreview
endfunction
command! MD call s:markdown_preview()

" One theme
" load and use the one theme by default dark
colorscheme one
" enable gui colors in the terminal, which looks nicer if supported
set termguicolors
" explicitly set the airline color theme
let g:airline_theme = 'one'
" automatically update missing features of theme when switching between shades
function! s:toggleTheme()
    if &background == 'light'
        set background=dark
    else
        set background=light
    endif
endfunction
nmap <silent> D :call <SID>toggleTheme()<cr>
augroup theme
    autocmd!
    function! s:updateTheme()
        if &background == 'light'
            " show illuminated words in a slightly darker gray compared to bg
            hi illuminatedWord guibg=#e6e6e6 ctermbg=238
            " match the fzf preview (bat) with the current shade
            let $BAT_THEME = 'OneHalfLight'
            " actually show missspelled words, one theme doesn't show them
            hi SpellBad guifg=NONE guibg=#ffccee guisp=NONE gui=NONE ctermfg=NONE ctermbg=225 cterm=NONE
            hi SpellRare guifg=NONE guibg=#ffeecc guisp=NONE gui=NONE ctermfg=NONE ctermbg=223 cterm=NONE
            hi SpellCap guifg=NONE guibg=#cceeff guisp=NONE gui=NONE ctermfg=NONE ctermbg=195 cterm=NONE
        else
            " show illuminated words in a slightly lighter gray compared to bg
            hi illuminatedWord guibg=#444444 ctermbg=238
            " match the fzf preview (bat) with the current shade
            let $BAT_THEME = 'TwoDark'
            " actually show missspelled words, one theme doesn't show them
            hi SpellBad guifg=NONE guibg=#663355 guisp=NONE gui=NONE ctermfg=NONE ctermbg=89 cterm=NONE
            hi SpellRare guifg=NONE guibg=#665533 guisp=NONE gui=NONE ctermfg=NONE ctermbg=94 cterm=NONE
            hi SpellCap guifg=NONE guibg=#335566 guisp=NONE gui=NONE ctermfg=NONE ctermbg=24 cterm=NONE
        endif
        " show special characters with a cyan background
        hi SpecialKey guibg=#00cccc ctermbg=44 guifg=bg ctermfg=bg
    endfunction
    au OptionSet background :call <SID>updateTheme()
augroup END
set background=dark
call <SID>updateTheme()

" Suda
" automatically open root owned files with sudo
let g:suda_smart_edit=1

" TComment
" don't set the default bindings
let g:tcomment_maps=0
" Toggle comments with gc in normal and visual mode
noremap gc :TComment<cr>
" Add or remove the comment marker with g< or g>
function! s:TCommentSpecial(mode)
    call tcomment#SetOption('mode_extra', a:mode)
    TComment | call tcomment#ResetOption()
endfunction
noremap <silent> g> :call <SID>TCommentSpecial('C')<cr>
noremap <silent> g< :call <SID>TCommentSpecial('U')<cr>

" Undotree
" toggle the undo tree easily
nnoremap <leader>u :UndotreeToggle<cr>:UndotreeFocus<cr>
set undodir=~/.vim/backup//
set undofile

" Load plugins and automatically generate helptags for them
packloadall
helptags ALL
