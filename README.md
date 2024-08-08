# schema-companion.nvim

Forked from the original repository [someone-stole-my-name/yaml-companion.nvim](https://github.com/someone-stole-my-name/yaml-companion.nvim) and expanded for a bit more modularity to work with multiple language servers like `yaml-language-server` and `helm-ls` at the same time as well as automatic Kubernetes CRD detection. I have been happily using the plugin with some caveats, so I wanted to refactor it a bit to match my current mostly Kubernetes working environment.

Currently in the dogfooding stage with matching all the resources, but the following features are available.

## Features

- Ability to add any kind of matcher, that can detect schema based on content.
- Kubernetes resources can be matched utilizing the repository [yannh/kubernetes-json-schema](https://github.com/yannh/kubernetes-json-schema). ![kubernetes](./resources/screenshots/kubernetes.png)
- Kubernetes CRD definitions can be matched utilizing the repository [datreeio/CRDs-catalog](https://github.com/datreeio/crds-catalog). ![kubernetes-crd](./resources/screenshots/kubernetes-crd.png)
- Change matcher variables on the fly, like the Kubernetes version. Do not be stuck with whatever `yaml-language-server` has hardcoded at the given time. ![kubernetes-version](./resources/screenshots/kubernetes-version.png)

## Installation

### lazy.nvim

```lua
return {
  "cenk1cenk2/schema-companion.nvim",
  dependencies = {
    { "neovim/nvim-lspconfig" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
  },
  config = function()
    require("schema-companion").setup({
      -- if you have telescope you can register the extension
      enable_telescope = true,
      matchers = {
        -- add your matchers
        require("schema-companion.matchers.kubernetes").setup({ version = "master" }),
      },
    })
  end,
}
```

## Configuration

Plugin has to be configured once, and the language servers can be added by extending the LSP configuration.

### Setup

The default plugin configuration for the setup function is as below.

```lua
require("schema-companion").setup({
  log_level = "info",
  formatting = true,
  enable_telescope = false,
  matchers = {},
  schemas = {},
}

```

### Language Server Configuration

You can automatically extend your configuration of the `yaml-language-server` or `helm-ls` with the following configuration.

```lua
require("lspconfig").yamlls.setup(require("schema-companion").setup_client({
  -- your yaml language server configuration
}))
```

### Manual Schemas

You can add custom schemas that can be activated manually through the telescope picker.

```lua
schemas = {
  {
    name = "Kubernetes master",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json",
  },
  {
    name = "Kubernetes v1.30",
    uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.3-standalone-strict/all.json",
  },
}
```

### Matchers

Adding custom matchers are as easy as defining a function that detects and handles a schema.

## Usage

### Schema Picker

You can map the `telescope` picker to any keybinding of your choice.

```lua
require("telescope").extensions.yaml_schema.select_schema()
```

Alternatively, you can use `vim.ui.select` to use the picker of your choice. In that case, you can bind/call the function as follows.

```lua
require("schema-companion.ui").select_schema()
```

### Current Schema

```lua
local schema = require("schema-companion").get_buf_schema(0)
```

This can be further utilized in `lualine` as follows.

```lua
-- your lualine configuration
require("lualine").setup({
  sections = {
    lualine_c = {
      {
        function()
          return ("%s"):format(require("schema-companion.context").get_buffer_schema(0).name)
        end,
        cond = function()
          return package.loaded["schema-companion"]
        end,
      },
    },
  },
})
```
