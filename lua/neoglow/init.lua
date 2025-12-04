local command = require("neoglow.command")
local config = require("neoglow.config")

---@class Neoglow
local M = {}

function M.setup(opts)
  if not M.ensure_glow_installed() then
    return
  end
  config.setup(opts)
  command.setup()
  M.setup_keymaps()
end

--- Setup keymaps for toggling preview
--- Only sets the toggle keymap if configured
function M.setup_keymaps()
  if config.options.keys then
    for _, keymap in ipairs(config.options.keys) do
      local lhs = keymap[1]
      local rhs = keymap[2]
      local desc = keymap.desc or "Neoglow keymap"
      vim.keymap.set("n", lhs, rhs, { desc = desc, noremap = true, silent = true })
    end
  end
end

--- Toggle Glow preview for the current markdown file
--- Can be called directly for lazy-loading with lazy.nvim keys
M.toggle = function()
  command.toggle()
end

--- Check if Glow is installed
---@return boolean
function M.ensure_glow_installed()
  local failure_message = "Glow is not installed. Please install Glow to use Neoglow."
  local output = command.run({
    "glow",
    "--version"
  })
  if output == nil then
    vim.notify(failure_message, vim.log.levels.ERROR)
    return false
  end
  return true
end

return M
