local command = require("neoglow.command")
local M = {}

local CURRENT_BUFFER = 0
local NEOGLOW_FILETYPE = "neoglow"

local subcommands = {
  open = function()
    M.open()
  end,
}

local state = {
  winnr = nil,
  src_bufnr = nil,
  src_filepath = nil,
  dest_bufnr = nil,
}

function M.setup()
  vim.api.nvim_create_user_command(
    "Neoglow",
    function(opts)
      if not M.ensure_glow_installed() then
        vim.notify("Glow is not installed. Please install Glow to use Neoglow.", vim.log.levels.ERROR)
        return
      end
      return M.command_controller(opts)
    end,
    {
      desc = "Toggle Glow Preview",
      nargs = '+',
      complete = function(arg_lead, cmdline, cursorpos)
        local subcommand_list = vim.tbl_keys(subcommands)
        return vim.tbl_filter(
          function(cmd)
            return cmd:find(arg_lead, 1, true) == 1
          end,
          subcommand_list
        )
      end,
    }
  )

  vim.keymap.set(
    "n",
    "<leader>og",
    "<cmd>Neoglow open<CR>",
    { noremap = true, silent = true }
  )
end

function M.command_controller(opts)
  local subcommand = opts.fargs[1]
  if subcommand and subcommands[subcommand] then
    subcommands[subcommand]()
  else
    vim.notify("Unknown subcommand: " .. tostring(subcommand), vim.log.levels.ERROR)
  end
end

function M.open()
  if M.is_filetype_neoglow() then
    vim.api.nvim_win_set_buf(state.winnr, state.src_bufnr)
    return
  end
  if not M.is_filetype_markdown() then
    vim.notify("Current file is not a markdown file.", vim.log.levels.WARN)
    return
  end
  state.winnr = vim.api.nvim_get_current_win()
  state.src_filepath = M.get_current_file_path()
  state.src_bufnr = vim.api.nvim_get_current_buf()
  state.dest_bufnr = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_name(state.dest_bufnr, "Glow preview: " .. state.src_filepath)

  local bufOpts = {
    { name = "filetype",  value = NEOGLOW_FILETYPE },
    { name = "buftype",   value = "nofile" },
    { name = "bufhidden", value = "wipe" },
  }

  for _, opt in ipairs(bufOpts) do
    vim.api.nvim_set_option_value(opt.name, opt.value, { buf = state.dest_bufnr })
  end

  vim.api.nvim_win_set_buf(state.winnr, state.dest_bufnr)

  local job = vim.fn.jobstart({ "glow", state.src_filepath }, {
    term = true,
    cwd = vim.fn.getcwd(),
  })

  vim.cmd("stopinsert")

  vim.api.nvim_buf_set_keymap(state.dest_bufnr, 'n', 'q', '', {
    callback = function()
      vim.api.nvim_win_set_buf(state.winnr, state.src_bufnr)
    end,
    noremap = true,
    silent = true,
    desc = "Switch preview window back to original buffer"
  })
end

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

--- Get the current file path
---@return string
function M.get_current_file_path()
  return vim.api.nvim_buf_get_name(CURRENT_BUFFER)
end

--- Check if the current buffer is a Neoglow buffer
---@return boolean
function M.is_filetype_neoglow()
  return vim.bo.filetype == NEOGLOW_FILETYPE
end

--- Check if the current buffer is a markdown file
---@return boolean
function M.is_filetype_markdown()
  return vim.bo.filetype == "markdown"
end

return M
