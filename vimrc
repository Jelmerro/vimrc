" Jelmerro's Vim configuration
" Configure Vim with autocompletion, keybindings, editorconfig and linting
" Suitable for Python, JavaScript, Vue, Docker and related files
" For updates and info go to https://github.com/Jelmerro/vimrc
" This file is released into the public domain, see UNLICENSE file for details

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
" enable auto indentation
set autoindent
" set the .swp and backup file location to ~/.vim/backup
call mkdir(expand("~/.vim/backup/"), "p")
set backupdir=~/.vim/backup//
set directory=~/.vim/backup//
set undodir=~/.vim/backup//
" reduce update time for swap
set updatetime=300
" show command suggestions at the position of the statusline
set wildmenu
" show and highlight search results when typing
set hlsearch
set incsearch
" indent wrapped lines the same as the start of the line
set breakindent
" highlight code snippets in markdown files
let g:markdown_fenced_languages=['bash=sh', 'css', 'html', 'js=javascript', 'python']
" find matching tags in html/xml documents using matchit
filetype plugin on
packadd! matchit
" don't keep netrw hist files
let g:netrw_dirhistmax=0

" Keybindings
" exit insert mode from terminal with normal keystrokes
tnoremap <Esc> <C-\><C-n>
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

" Airline
" always show airline as the statusline without showing the mode a second time
set laststatus=2
set noshowmode
" only enable relevant extensions
let g:airline_extensions=['coc', 'fugitiveline', 'netrw', 'term', 'virtualenv']

" COC (code suggestions, diagnostics and refactoring)
" find or update definitions
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-rename)"
" autoformat code based on linter
function! s:format_code()
    if index(['javascript','vue'], &filetype) >= 0
        call CocAction('runCommand', 'eslint.executeAutofix')
    else
        call CocAction('format')
    endif
endfunction
noremap <silent> <space>f :call <SID>format_code()<cr>
" always show signcolumn to prevent flashes
set signcolumn=yes
" jump to diagnostics or the documentation
nmap <silent> <C-k> <Plug>(coc-diagnostic-prev)
nmap <silent> <C-j> <Plug>(coc-diagnostic-next)
function! s:show_documentation()
    if index(['vim','help'], &filetype) >= 0
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
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
" expand snippet suggestion
imap <silent> <S-Tab> <Plug>(coc-snippets-expand)
imap <silent> <Tab> <Plug>(coc-snippets-expand)

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

" Instant Markdown
" disable autostart when opening a file
let g:instant_markdown_autostart=0
" Add a single startup command that also can also restart
function! s:markdown_preview()
    silent! InstantMarkdownStop
    silent! InstantMarkdownPreview
endfunction
command MD call s:markdown_preview()

" Onedark theme
" load and use the onedark theme
packadd! onedark.vim
colorscheme onedark
" enable gui colors in the terminal, which looks nicer if supported
set termguicolors
" show illuminated words in relatively light gray
hi illuminatedWord guibg=#444444 ctermbg=238
" show special characters in cyan
hi NonText guifg=#00cccc ctermfg=44
hi SpecialKey guifg=#00cccc ctermfg=44

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
    call tcomment#SetOption("mode_extra", a:mode)
    TComment | call tcomment#ResetOption()
endfunction
noremap <silent> g> :call <SID>TCommentSpecial("C")<cr>
noremap <silent> g< :call <SID>TCommentSpecial("U")<cr>

" Load plugins and automatically generate helptags for them
packloadall
helptags ALL
