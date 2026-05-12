-- ==============================================================================
-- User Commands
-- ==============================================================================

-- :W — write with sudo if :w fails (read-only FS, Permission denied, ...)
vim.api.nvim_create_user_command("W", function()
  if pcall(vim.cmd.write) then return end
  local path = vim.fn.shellescape(vim.fn.expand("%:p"))
  vim.cmd("silent write !sudo tee " .. path .. " > /dev/null")
  vim.cmd("redraw!")
  vim.cmd("edit!")
end, { desc = "Write file, retry with sudo if :w fails" })
