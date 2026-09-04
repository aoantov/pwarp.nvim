# PWarp (Project Warp)

## Description

#### Pet project to quickly switch between defined projects

#### Attempt at first Neovim plugin

## Installation

### lazy.nvim

```lua
return {
  "aoantov/pwarp.nvim",
  -- used to disable plugin
  -- enabled = false
  opts = {
    enabled = true, -- can disable plugin (enabled by default)
    config = "/path/to/config/file" -- path to JSON config file (overrides all properties configured through opts)
    projects = { -- projects to switch between
      {
        name = "project",
        path = "path/to/project"
      }
    }
  }
}
```

## Dependencies

- neovim >= 0.11
- telescope.nvim

## Methods

#### List projects

```lua
require("pwarp").list() -- list (telescope) all configured projects
```

#### Go to specific project

```lua
require("pwarp").go_to("project_name") -- go to specific project
```

## Commands

- `Warp` - list all configured projects and select one to go to
- `WarpTo` - go to specific project by name
