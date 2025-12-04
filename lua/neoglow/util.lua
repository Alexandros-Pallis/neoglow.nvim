local config = require("neoglow.config")
local M = {}

--- Check if the minimum nvim version criteria are met
--- @return boolean
M.ensure_nvim_version = function()
  if vim.fn.has("nvim-" .. config.MIN_NVIM_VERSION) ~= 1 then
    vim.notify(
      "neoglow.nvim requires Neovim >= " .. config.MIN_NVIM_VERSION,
      vim.log.levels.ERROR,
      { title = "neoglow.nvim" }
    )
    return false
  end
  return true
end

--- Get the current file path
---@return string
function M.get_current_file_path()
  return vim.api.nvim_buf_get_name(config._CURRENT_BUFFER)
end

--- Check if the current buffer is a Neoglow buffer
---@return boolean
function M.is_filetype_neoglow()
  return vim.bo.filetype == config._NEOGLOW_FILETYPE
end

--- Check if the current buffer is a markdown file
---@return boolean
function M.is_filetype_markdown()
  return vim.bo.filetype == config._MARKDOWN_FILETYPE
end

return M
