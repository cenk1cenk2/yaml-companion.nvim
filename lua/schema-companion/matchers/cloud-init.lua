local M = {}

M.name = "Cloud-Init"

M.config = {}

---@type schema_companion.MatcherSetupFn
function M.setup(config)
  M.config = vim.tbl_deep_extend("force", {}, M.config, config)

  return M
end

---@type schema_companion.MatcherMatchFn
function M.match(bufnr)
  if vim.regex("^#cloud-config"):match_str(vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]) then
    return {
      name = "cloud-init",
      uri = "https://raw.githubusercontent.com/canonical/cloud-init/main/cloudinit/config/schemas/versions.schema.cloud-config.json",
    }
  end
end

---@type schema_companion.Matcher
return M
