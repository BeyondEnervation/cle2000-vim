# vim-cle2000

Vim/Neovim syntax highlighting, filetype detection, and comment support for the CLE-2000 scripting language used with DRAGON (e.g. DRAGON5) reactor physics tools.

## Attribution

This project adapts the CLE-2000 grammar from the VS Code extension by
Charles Bienvenue:

https://github.com/CBienvenue/cle2000-vscode

All credit for the original grammar goes to Charles Bienvenue. This project is not affiliated with or endorsed by the original author.

The upstream project is licensed under the MIT License. A copy of the upstream license is included in `LICENSE.upstream`.

## AI Usage Disclaimer

Content produced with the help ChatGPT-5.4 in the conversion of the original VS Code grammar to Vim/Neovim syntax highlighting. The generated code was reviewed and modified by a human to ensure accuracy and quality and remove bugs (e.g. * comment highlighting vs * operator highlighting).

## Features

- Syntax highlighting for CLE-2000
- Filetype detection for `.c2m` and `.x2m`
- `commentstring` support for Vim/Neovim integrations
- Support for CLE-2000 module blocks such as `:: ... ;`
- Full-line `*` comments highlighted as comments

## Installation

### lazy.nvim
```lua
{
  "BeyondEnervation/vim-cle2000",
  ft = { "cle2000" },
  lazy=false,
}
```

### Manual installation

Copy the plugin directories into:
- Neovim: ~/.config/nvim/
- Vim: ~/.vim/

This repo provides:
- syntax/cle2000.vim
- ftdetect/cle2000.vim
- ftplugin/cle2000.vim

## Filetype detection

Recognized file extensions:
- .c2m
- .x2m

## Verification

Open a CLE-2000 file and run:
```vim
:set filetype?
:set commentstring?
```

Expected output:
```vim
filetype=cle2000
commentstring=* %s
```
