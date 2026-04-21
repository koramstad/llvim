# Opencode Neovim Plugin

A lightweight Neovim plugin written in Lua JIT that integrates the `opencode` CLI directly into your editor via a beautiful `nui.nvim` dialog.

## Features

- **Interactive Dialog**: A floating `nui.nvim` popup for entering queries.
- **Instant Results**: On pressing `<Enter>`, the plugin calls the `opencode` CLI and displays the response in a secondary floating window directly below the input.
- **Seamless Integration**: Minimalistic UI that stays out of your way.

## Installation

1. Clone this repository.
2. Add the directory to your Neovim `runtimepath`.

Alternatively, if you use a plugin manager, add the local path to your configuration.

## Usage

Press `<leader>oc` in Normal mode or run `:Opencode` to open the Opencode dialog.

1. Type your query in the floating input box.
2. Press `<Enter>` to submit.
3. View the response in the window that appears below.
4. Press `<Esc>` to close the dialog.

## Requirements

- Neovim
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)
- `opencode` CLI installed and available in your PATH.

## Development

To run the plugin in a test environment:

```bash
./start_nvim.sh
```
