return {
  "hoob3rt/lualine.nvim",
  lazy = false,
  dependencies = {},
  config = function()
    -- Eviline config for lualine
    -- Author: shadmansaleh
    -- Credit: glepnir
    local lualine = require("lualine")

    -- Color table for highlights
    -- stylua: ignore
    local colors = {
      bg       = '#101019',
      fg       = '#cdd6f4',
      yellow   = '#f9e2af',
      cyan     = '#89dceb',
      darkblue = '#45475a',
      green    = '#a6e3a1',
      orange   = '#fab387',
      violet   = '#cba6f7',
      magenta  = '#f5c2e7',
      blue     = '#89b4fa',
      red      = '#f38ba8',
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
    }

    -- Config
    local config = {
      options = {
        -- Disable sections and component separators
        component_separators = "",
        section_separators = "",
        theme = {
          -- We are going to use lualine_c an lualine_x as left and
          -- right section. Both are highlighted by c theme .  So we
          -- are just setting default looks o statusline
          normal = { c = { fg = colors.fg, bg = colors.bg } },
          inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
        disabled_filetypes = { "NvimTree", "alpha" },
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    }

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x ot right section
    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    ins_left {
      -- Left section
      -- function to see current file size
      function()
        local function format_file_size(file)
          local size = vim.fn.getfsize(file)
          if size <= 0 then return "" end
          local sufixes = {"b", "k", "m", "g"}
          local i = 1
          while size > 1024 do
            size = size / 1024
            i = i + 1
          end
          return string.format("%.1f%s", size, sufixes[i])
        end
        local file = vim.fn.expand("%:p")
        if string.len(file) == 0 then return "" end
        return format_file_size(file)
      end,
      color = {fg = colors.green}, -- Sets highlighting of component
      padding = 1, -- We don't need space before this
    }

    ins_left {
      "filename",
      condition = conditions.buffer_not_empty,
      color = {fg = colors.magenta, gui = "bold"}
    }

    ins_left {"location"}

    ins_left {"progress"}

    ins_left {
      "diagnostics",
      sources = {"nvim_lsp"},
      symbols = {error = "E", warn = "W", info = "I", hint = "H"},
      color_error = colors.red,
      color_warn = colors.yellow,
      color_info = colors.cyan,
      color_hint = colors.cyan,
    }

    ins_right {
      "branch",
      icon = "",
      condition = conditions.check_git_workspace,
      color = {fg = colors.violet, gui = "bold"}
    }

    ins_right {
      "diff",
      -- Is it me or the symbol for modified us really weird
      symbols = {added = " ", modified = "柳", removed = " "},
      color_added = colors.green,
      color_modified = colors.orange,
      color_removed = colors.red,
      condition = conditions.hide_in_width,
    }

    ins_right {
      function()
        if not conditions.hide_in_width() then
          return "%<"
        end
      end,
      color = {fg = colors.blue, gui = "bold"}
    }

    ins_right {"filetype"}

    -- Now don't forget to initialize lualine
    lualine.setup(config)
  end,
  keys = {},
}
