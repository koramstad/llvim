#!/bin/bash

# Get the absolute path of the current directory
CURRENT_DIR=$(pwd)

# Start nvim, add current dir to runtimepath, and source the plugin
nvim -c "lua vim.opt.runtimepath:append('${CURRENT_DIR}')" -c "source ${CURRENT_DIR}/plugin/opencode-plugin.lua" "$@"



