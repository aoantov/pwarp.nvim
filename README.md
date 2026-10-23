# PWarp (Project Warp)

## Description

#### A lightweight Neovim plugin for quickly jumping between project

## Installation

### lazy.nvim

```lua
return {
  "aoantov/pwarp.nvim",
  -- used to disable plugin
  -- enabled = false
  opts = {
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

## Buffers

Open file buffers are remembered per project (saved when warping away or quitting Neovim, stored in `stdpath('data')/pwarp_buffers.json`) and restored when you warp back.

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
- `WarpBuffReset` - go to specific project by name
