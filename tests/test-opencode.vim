set runtimepath+=/home/koramstad/projects/llvim
set runtimepath+=~/.local/share/nvim/lazy/nui.nvim
source /home/koramstad/projects/llvim/plugin/opencode-plugin.lua
lua require("opencode-plugin").open()
sleep 10
qa!