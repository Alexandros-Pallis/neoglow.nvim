local config = require("neoglow.config")
local util = require("neoglow.util")
local M = {}

local COMMAND_READ = "r"

local subcommands = {
  toggle = function()
    M.toggle()
  end,
}

M.setup = function()
  vim.api.nvim_create_user_command(
    "Neoglow",
    function(input)
      return M.command_controller(input)
    end,
    {
      desc = "Neoglow command controller",
      nargs = '+',
      complete = M.complete,
    }
  )
end

--- Command controller for Neoglow
---@param input table
function M.command_controller(input)
  local subcommand = input.fargs[1]
  if subcommand and subcommands[subcommand] then
    subcommands[subcommand]()
  else
    vim.notify("Unknown subcommand: " .. tostring(subcommand), vim.log.levels.ERROR)
  end
end

function M.toggle()
  if util.is_filetype_neoglow() then
    vim.api.nvim_win_set_buf(config._state.winnr, config._state.src_bufnr)
    return
  end
  if not util.is_filetype_markdown() then
    vim.notify("Current file is not a markdown file.", vim.log.levels.WARN)
    return
  end
  config._state.winnr = vim.api.nvim_get_current_win()
  config._state.src_filepath = util.get_current_file_path()
  config._state.src_bufnr = vim.api.nvim_get_current_buf()
  config._state.dest_bufnr = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_name(config._state.dest_bufnr, "Glow preview: " .. config._state.src_filepath)

  local bufOpts = {
    { name = "filetype",  value = config._NEOGLOW_FILETYPE },
    { name = "buftype",   value = "nofile" },
    { name = "bufhidden", value = "wipe" },
  }

  for _, opt in ipairs(bufOpts) do
    vim.api.nvim_set_option_value(opt.name, opt.value, { buf = config._state.dest_bufnr })
  end

  vim.api.nvim_win_set_buf(config._state.winnr, config._state.dest_bufnr)

  vim.fn.jobstart({ "glow", config._state.src_filepath }, {
    term = true,
    cwd = vim.fn.getcwd(),
  })

  vim.cmd("stopinsert")

  if not config._state.dest_bufnr then
    return
  end

  vim.api.nvim_buf_set_keymap(config._state.dest_bufnr, 'n', 'q', '', {
    callback = function()
      vim.api.nvim_win_set_buf(config._state.winnr, config._state.src_bufnr)
    end,
    noremap = true,
    silent = true,
    desc = "Close Neoglow preview"
  })
end

---  Run a shell command and return its output.
---@param command_list string[]
---@return string|nil
M.run = function(command_list)
  local command_string = table.concat(command_list, " ")
  local handle = io.popen(command_string, COMMAND_READ)
  if handle == nil then
    return nil
  end
  local result = handle:read("*a")
  if result == "" then
    return nil
  end
  return result
end

--- Get completion candidates for Neoglow commands.
---@param arg_lead string
---@param cmdline string
---@param cursorpos number
---@return string[]
M.complete = function(arg_lead, cmdline, cursorpos)
  local subcommand_list = vim.tbl_keys(subcommands)
  return vim.tbl_filter(
    function(cmd)
      return cmd:find(arg_lead, 1, true) == 1
    end,
    subcommand_list
  )
end

return M
