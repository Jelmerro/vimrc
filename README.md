vimrc
=====

### Configure Vim with autocompletion, keybindings, editorconfig and linting

# Overview

- Easy to install and expand with other plugins
- Deterministic configuration, disables any system settings
- Intelligent autocomplete using CoC
- Linting with eslint, tsserver, flake8 and pylint (including configuration)
- Improved syntax highlighting for JavaScript, Vue, SCSS and Pug
- Fuzzy code and file search using FZF and ripgrep
- One Dark theme everywhere
- My vimrc to configure all of the above and more

# Supported languages

All languages supported by Vim are supported.
These are all languages that are (somewhat) enhanced by using this vimrc:

__Bash__, __CSS__, Docker, Handlebars, __HTML__, __JavaScript__, __JSON__, Less,
__Markdown__, __Python__, Pug, Razor, Ren'Py, SCSS, Tailwind, TypeScript,
__Vue__, Vim, XML, YAML.

Languages in __bold__ are the main focus of this vimrc project.
However, the install script can be easily expanded to change the list of plugins.

# Dependencies

These are the system packages that my vimrc depends on,
none of which are installed automatically and some of which are optional.
Linters and Vim plugins ARE installed by the `install.sh` script.

## Required

- Git
- Vim 8 or higher
- Python3 with Pip3
- NodeJS with Npm

## Optional

- FZF (fzf) - for using any kind of fuzzy search commands, such as :Files
- Ripgrep (rg) - for using the :Rg command to fuzzy search file contents

# Install

To install my vimrc and related config, use the `install.sh` script.
The script has been tested to work on a variety of Linux distributions,
and PRs are encouraged to broaden the support for other platforms.
The install script will ask you to install system packages manually,
but all linters and plugins will be installed by the script to these locations:

- `~/.vim/` for all Vim configuration, including the vimrc
- `~/.local/` for npm and pip packages (mostly linters and parsers)
- `~/.eslintrc.json` contains the eslint config
- `~/.config/coc/` for all autocompletion related packages

# Features and usage

## Base

- Distribution independent configuration, system vimrc changes are reset
- User-only installation, see "Install" for a list of locations
- Default to 4 spaces for all files, unless overwritten by Editorconfig
- Show line numbers, special characters, trailing whitespace and colorcolumn
- Store all vim swap and backup files in ~/.vim/backup
- Enable fenced markdown languages and the matchit plugin
- More direct feedback using search highlighting, wildmenu, showcmd and such
- Leader key is set to the `Space` key
- Indent-based folding that can be toggled with `<leader>t`

## Plugins

This is a list of the plugins that are installed to add additional features.
Changes to the default usage/bindings are listed as well.
Not all plugins are listed, as some of them are merely to improve the syntax,
a list of these can be found at the bottom of this readme.

### Airline

- Themed statusline with limited extensions loaded, including CoC and venv

### CoC

For Conqueror of Completion the following keys are mapped in normal mode:

- `gd` - jump to definition
- `gy` - jump to type definition
- `gi` - list and jump to implementation
- `gr` - list and jump to references
- `gn` - rename at cursor position
- `<leader>f` - autoformat code
- `<c-k>` - jump to previous diagnostic
- `<c-j>` - jump to next diagnostic
- `K` - show CoC documentation or the vim help pages

The signcolumn is also populated by CoC, with all diagnostics displayed as `>>`,
although each level from hint to error has a different color.
Git difference is displayed as a single character, such as `+`, `.` or `~`.

This plugin is also used for autocompletion, which will show automatically in insert mode.
Suggestions are never automatically applied, but you can select them with `<c-n>` and `<c-p>`.
You can then immediately continue typing without needing to press anything else.
The only exception is made for snippets, which do need to be expanded with Tab.
Unlike other configurations, the Tab key can not be used to modify whitespace,
with this vimrc we use Vim's regular `<c-d>` and `<c-t>` to do so.
Or `<<` and `>>` to do the same outside of insert mode.

### Editconfig

- Will automatically activate when a config file is present

### FZF

- Open the file finder with `<leader>e`
- Find text in files using ripgreg using `<leader>r`
- Switch buffers based on filename by pressing `<leader>b`
- Or use many more commands such as `:GFiles` or `:Commits`

### Fugitive

- Use many commands such as :Gblame or :Gdiffsplit to access git within Vim

### Illuminate

- Automatically highlights the same words in a relatively light gray color

### Instant Markdown

- The preview won't open automatically
- Open the preview with the custom :MD command

### One Dark

- Theme for code, FZF sub-windows, the statusline, the tabs and even terminals

### Reword

- Rename camelCaseWords or snake_case_words all the same with `:Reword`

### Snippets

- A collection of snippets that will be suggested by CoC
- Use the Tab key to expand the highlighted snippet

### Suda

- Allows you to save files that are owned by root
- Opens a copy and asks for sudo user password confirmation on write

### TComment

In normal or visual mode, these keybindings can be used:

- `gc` - toggle comments (add if missing, remove if already present)
- `g>` - add comment markers (will add a second marker if already present)
- `g<` - remove comment markers (will do nothing if missing)

### Undotree

- Toggle the Undotree with `<leader>u`, which automatically shifts the focus there

# Uninstall

When uninstalling, the `uninstall.sh` script will do the following:

- Delete `~/.vim/`, `~/.eslintrc.json` and `~/.config/coc/`
- Ask for each of the installed packages if you want to uninstall them

# License

ALL files in this repository are created by Jelmer van Arnhem.
You can copy, share and modify them without limitation,
see the UNLICENSE file for more details.
The referenced projects are covered by different licenses, check them out below.

# Links to all referenced projects

## Linters

[autopep8](https://github.com/hhatto/autopep8),
[bash-language-server](https://github.com/mads-hartmann/bash-language-server),
[eslint](https://github.com/eslint/eslint),
[eslint-plugin-vue](https://github.com/vuejs/eslint-plugin-vue),
[instant-markdown-d](https://github.com/suan/instant-markdown-d),
[flake8](https://gitlab.com/pycqa/flake8),
[pylint](https://github.com/PyCQA/pylint)

## Vim plugins

[chaimleib/vim-renpy](https://github.com/chaimleib/vim-renpy),
[editorconfig/editorconfig-vim](https://github.com/editorconfig/editorconfig-vim),
[digitaltoad/vim-pug](https://github.com/digitaltoad/vim-pug),
[honza/vim-snippets](https://github.com/honza/vim-snippets),
[joshdick/onedark.vim](https://github.com/joshdick/onedark.vim),
[junegunn/fzf.vim](https://github.com/junegunn/fzf.vim),
[lambdalisue/suda.vim](https://github.com/lambdalisue/suda.vim),
[lambdalisue/reword.vim](https://github.com/lambdalisue/reword.vim),
[neoclide/coc.nvim](https://github.com/neoclide/coc.nvim),
[mbbill/undotree](https://github.com/mbbill/undotree),
[pangloss/vim-javascript](https://github.com/pangloss/vim-javascript),
[posva/vim-vue](https://github.com/posva/vim-vue),
[RRethy/vim-illuminate](https://github.com/RRethy/vim-illuminate),
[suan/vim-instant-markdown](https://github.com/suan/vim-instant-markdown),
[tomtom/tcomment\_vim](https://github.com/tomtom/tcomment_vim),
[tpope/vim-fugitive](https://github.com/tpope/vim-fugitive),
[vim-airline/vim-airline](https://github.com/vim-airline/vim-airline),
[vim-ide/scss-syntax.vim](https://github.com/vim-ide/scss-syntax.vim)

## CoC extensions

[coc-css](https://github.com/neoclide/coc-css),
[coc-docker](https://github.com/josa42/coc-docker),
[coc-eslint](https://github.com/neoclide/coc-eslint),
[coc-git](https://github.com/neoclide/coc-git),
[coc-highlight](https://github.com/neoclide/coc-highlight),
[coc-html](https://github.com/neoclide/coc-html),
[coc-json](https://github.com/neoclide/coc-json),
[coc-markdownlint](https://github.com/fannheyward/coc-markdownlint),
[coc-python](https://github.com/neoclide/coc-python),
[coc-snippets](https://github.com/neoclide/coc-snippets),
[coc-sources](https://github.com/neoclide/coc-sources),
[coc-syntax](https://github.com/neoclide/coc-sources),
[coc-tailwindcss](https://github.com/iamcco/coc-tailwindcss),
[coc-tsserver](https://github.com/neoclide/coc-tsserver),
[coc-vetur](https://github.com/neoclide/coc-vetur),
[coc-vimlsp](https://github.com/iamcco/coc-vimlsp),
[coc-yaml](https://github.com/neoclide/coc-yaml)

## Other

[fzf](https://github.com/junegunn/fzf),
[ripgrep](https://github.com/BurntSushi/ripgrep)
