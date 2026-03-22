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

## Commands

#### List projects

```lua
require("pwarp").list() -- list (telescope) all configured projects
```

#### Go to specific project

```lua
require("pwarp").goto("project_name") -- go to specific project
```
