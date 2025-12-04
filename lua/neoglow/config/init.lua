local M = {}

M._CURRENT_BUFFER = 0
M._MARKDOWN_FILETYPE = "markdown"
M._NEOGLOW_FILETYPE = "neoglow"
M.MIN_NVIM_VERSION = "0.7.4"

--- @class Config
M.defaults = {
  keys = {},
}

--- @type Config
M.options = {}

--- @class State
M._state = {
  winnr = nil,
  src_bufnr = nil,
  dest_bufnr = nil,
  src_filepath = nil,
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

return M
