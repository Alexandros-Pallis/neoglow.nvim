local M = {}

local COMMAND_READ = "r"

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

return M
