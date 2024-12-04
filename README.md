vimrc
=====

### Configure Vim with autocompletion, keybindings, editorconfig and linting

# Overview

- Easy to install and expand with other plugins
- Deterministic configuration, disables any system settings
- Intelligent autocomplete using CoC
- Linting with eslint, tsserver, flake8, pylint, shellcheck and shfmt
- Fuzzy code and file search using FZF and ripgrep
- Vim One theme everywhere in both light and dark shades
- My vimrc to configure all of the above and more

# Install

To install my vimrc and related config, use the `install.sh` script.
The script has been tested to work on a variety of Linux distributions,
and PRs are encouraged to broaden the support for other platforms.
The install script will ask you to install system packages manually,
but all linters and plugins will be installed by the script to these locations:

- `~/.vim/` for all Vim configuration, including the vimrc
- `~/.config/coc/` for all autocompletion related packages

Optionally you can append `./install.sh` with 'clean' or 'config-only',
which will wipe the existing .vim folder or only install the config, respectively.

## Optional

These parts can optionally be installed to improve the experience for these domains.

### FZF

For fuzzy searching of any kind fzf is required, such as for `:Files`/`<leader>e`.
To also fuzzy search in file contents, install Ripgrep and use `:Rg`/`<leader>r`.
Finally, for showing file preview with syntax highlighting, install bat.

### Python3

Python is entirely optional, but highly recommended to improve Vim's Python features,
as well as showing highlights, suggestions and diagnostics of Pyright in Vim.
To also use additional linters and formatters, simply install them to make use of them,
support is present for: autopep8, black, flake8, pylint, pyflakes, pyink and more.
These can either be installed from system `python3-*` packages or via pip,
such as `sudo dnf install python3-pylint` or `pip install --user flake8`.

### Bash

Basic highlighting and suggestions are supported by the base install,
but linting and formatting is provided via the NodeJS-driven LSP `bash-language-server`.
This package can be installed via npm using `npm i -g bash-language-server@latest`.

- ShellCheck (shellcheck) - for linting sh/bash files (requires NodeJS for LSP)
- shfmt - for formatting sh/bashf files (requires NodeJS for LSP)

### Markdown

Markdown highlighting and suggestions are supported by the base install,
but web previews via `:MD` are provided by the NodeJS-driven LSP `instant-markdown-d`.
This package can be installed via npm using `npm i -g instant-markdown-d@latest`.

### NodeJS

While NodeJS itself is required to install CoC's LSP plugins to `~/.config/coc`,
there are other recommended optional NodeJS related packages and tools.
The packages mentioned above for Bash and Markdown tooling are highly recommended,
so be sure to set your npm prefix to a user writable place: `npm config set prefix $HOME/.local`.
For linting, you can install the eslint npm package inside specific projects,
be sure to check out my [eslint-config](https://github.com/Jelmerro/eslint-config) for it.

# Features and usage

## Base

- Distribution independent configuration, system vimrc changes are reset
- User-only installation, see "Install" for a list of locations
- Default to 4 spaces for all files, unless overwritten by local configuration
- Show line numbers, special characters, trailing whitespace and colorcolumn
- Store all vim swap and backup files in ~/.vim/backup
- Enable fenced markdown languages and the matchit plugin
- More direct feedback using search highlighting, wildmenu, showcmd and such
- Leader key is set to the `Space`, toggle indent-based folding with `<leader>t`
- Toggle line wrap with `W` and toggle spellchecker with `<leader>ss`
- Switch between English, Dutch and combined with `<leader>s` + `e`, `n` or `b` respectively
- Clear the search with `\` and exit insert/terminal modes with `kj`

See the `vimrc` file for details and mappings.

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
- `<leader>c` - execute automatic diagnostic fix for the code (or selection)
- `<leader>d` - show a list of diagnostics
- `<c-k>` - jump to previous diagnostic
- `<c-j>` - jump to next diagnostic
- `K` - show CoC documentation or the vim help pages

The signcolumn is also populated by CoC, with all diagnostics displayed as `>>`,
although each level from hint to error has a different color.
Git difference is displayed as a single character, such as `+`, `.` or `~`.

This plugin is also used for autocompletion, which will show automatically in insert mode.
Suggestions are never automatically applied, but you can select them with `<c-n>` and `<c-p>`.
You can then immediately continue typing without needing to press anything else,
though you can also choose to expand the snippet or auto-import using the Tab key.
The Tab key can not be used to modify whitespace as this would conflict with `<c-i>`,
please use Vim's regular `<c-d>` and `<c-t>` to do so inside insert mode.
Outside of insert mode you can use `<<` and `>>` to do the same thing.

### Editorconfig

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

### Vim One

- Theme for code, FZF sub-windows, the statusline, the tabs and even terminals
- Switch between light and dark with `D`

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

### Context

- Show the context of the current function or path you are editing at the top

# Uninstall

The `uninstall.sh` script will simply delete the following locations:

- `~/.vim/spell/`
- `~/.vim/pack/`
- `~/.vim/vimrc`
- `~/.vim/coc-settings.json`
- `~/.config/coc/`

# License

All files in this repository are created by Jelmer van Arnhem.
This project is released as free software via MIT, see LICENSE file for details.
The referenced projects are covered by different licenses, check them out below.

# Links to all referenced projects

## Optional

### NodeJS

[eslint-config](https://github.com/Jelmerro/eslint-config)

### FZF

[fzf](https://github.com/junegunn/fzf),
[bat](https://github.com/sharkdp/bat),
[ripgrep](https://github.com/BurntSushi/ripgrep)

### Python3

[autopep8](https://github.com/hhatto/autopep8),
[flake8](https://gitlab.com/pycqa/flake8),
[pylint](https://github.com/PyCQA/pylint)

### Bash

[shellcheck](https://github.com/koalaman/shellcheck),
[shfmt](https://github.com/mvdan/sh)

### Markdown

[bash-language-server](https://github.com/mads-hartmann/bash-language-server),
[instant-markdown-d](https://github.com/suan/instant-markdown-d)

## Vim plugins

[ap/vim-css-color](https://github.com/ap/vim-css-color),
[chaimleib/vim-renpy](https://github.com/chaimleib/vim-renpy),
[editorconfig/editorconfig-vim](https://github.com/editorconfig/editorconfig-vim),
[honza/vim-snippets](https://github.com/honza/vim-snippets),
[junegunn/fzf.vim](https://github.com/junegunn/fzf.vim),
[laggardkernel/vim-one](https://github.com/laggardkernel/vim-one),
[lambdalisue/suda.vim](https://github.com/lambdalisue/suda.vim),
[mbbill/undotree](https://github.com/mbbill/undotree),
[neoclide/coc.nvim](https://github.com/neoclide/coc.nvim),
[pangloss/vim-javascript](https://github.com/pangloss/vim-javascript),
[RRethy/vim-illuminate](https://github.com/RRethy/vim-illuminate),
[suan/vim-instant-markdown](https://github.com/suan/vim-instant-markdown),
[tomtom/tcomment\_vim](https://github.com/tomtom/tcomment_vim),
[tpope/vim-fugitive](https://github.com/tpope/vim-fugitive),
[vim-airline/vim-airline](https://github.com/vim-airline/vim-airline),
[wellle/context.vim](https://github.com/wellle/context.vim)

## CoC extensions

[coc-css](https://github.com/neoclide/coc-css),
[coc-eslint](https://github.com/neoclide/coc-eslint),
[coc-git](https://github.com/neoclide/coc-git),
[coc-highlight](https://github.com/neoclide/coc-highlight),
[coc-html](https://github.com/neoclide/coc-html),
[coc-json](https://github.com/neoclide/coc-json),
[coc-pyright](https://github.com/fannheyward/coc-pyright),
[coc-snippets](https://github.com/neoclide/coc-snippets),
[coc-tsserver](https://github.com/neoclide/coc-tsserver),
[coc-vimlsp](https://github.com/iamcco/coc-vimlsp)
