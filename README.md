# cle2000-vim

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
  "BeyondEnervation/cle2000-vim",
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

## Optional `mini.comment` integration for CLE-2000 with lazy.nvim

This integration is **optional** and is intended for users of [`echasnovski/mini.comment`](https://github.com/echasnovski/mini.comment).

It keeps the default CLE-2000 editor comment style as:

```vim
commentstring=! %s
```

while also making `gcc` behave nicely on existing first-column `*` comments:

- normal code line: `gcc` uses `!`
- line beginning with `*` in column 1: `gcc` removes that `*` comment instead of producing `! * ...`

Users who want special `mini.comment` behavior can add the following config themselves by Creating a file such as:

```text
~/.config/nvim/lua/plugins/cle2000-mini-comment.lua
```

with this content:

```lua
local function cle2000_is_star_comment(line)
    return line:match("^%*") ~= nil
end

local function cle2000_toggle_star_lines(line_start, line_end)
    local lines = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)
    local all_star = true

    for _, line in ipairs(lines) do
        if not cle2000_is_star_comment(line) then
            all_star = false
            break
        end
    end

    if all_star then
        for i, line in ipairs(lines) do
            lines[i] = line:gsub("^%*", "", 1)
        end
        vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, false, lines)
        return true
    end

    return false
end

local function cle2000_toggle_comment_line()
    local line_nr = vim.fn.line(".")
    local line = vim.api.nvim_buf_get_lines(0, line_nr - 1, line_nr, false)[1] or ""

    if cle2000_is_star_comment(line) then
        local uncommented = line:gsub("^%*", "", 1)
        vim.api.nvim_buf_set_lines(0, line_nr - 1, line_nr, false, { uncommented })
    else
        require("mini.comment").toggle_lines(line_nr, line_nr)
    end
end

local function cle2000_toggle_comment_visual()
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")

    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end

    if not cle2000_toggle_star_lines(start_line, end_line) then
        require("mini.comment").toggle_lines(start_line, end_line)
    end
end

return {
    {
        "nvim-mini/mini.comment",
        opts = function(_, opts)
            opts = opts or {}
            local old_options = opts.options or {}

            opts.options = vim.tbl_deep_extend("force", old_options, {
                custom_commentstring = function()
                    if vim.bo.filetype == "cle2000" then
                        return "! %s"
                    end
                end,
            })

            return opts
        end,
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "cle2000",
                callback = function(args)
                    vim.bo[args.buf].commentstring = "! %s"

                    vim.keymap.set("n", "gcc", cle2000_toggle_comment_line, {
                        buffer = args.buf,
                        desc = "Toggle CLE-2000 comment",
                    })

                    vim.keymap.set("x", "gc", function()
                        cle2000_toggle_comment_visual()
                    end, {
                        buffer = args.buf,
                        desc = "Toggle CLE-2000 comments",
                    })
                end,
            })
        end,
    },
}
```
