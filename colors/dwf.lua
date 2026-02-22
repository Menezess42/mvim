vim.cmd("highlight clear")
vim.cmd("syntax reset")
vim.g.colors_name = "dwf"

local colors = {
  base00 = "#22303C",
  base01 = "#3B4A56",
  base02 = "#56636F",
  base03 = "#415A77",
  base04 = "#6C7A89",
  base05 = "#E6D5B8",
  base06 = "#CFC8B5",
  base07 = "#ECE6D8",

  gold      = "#DDAA33",
  gold_soft = "#C79A2B",
  ochre     = "#B68A3A",
  amber     = "#D4A017",
  bronze    = "#CD7F32",
  orange    = "#CC6E2E",

  blue_var  = "#6C7A89",
  blue_fn   = "#415A77",
  blue_type = "#81A1C1",
}

local highlight_groups = {
  Normal       = { fg = colors.base05, bg = colors.base00 },
  Comment      = { fg = colors.base03, italic = true },

  Constant     = { fg = colors.bronze },
  String       = { fg = colors.ochre },
  Function     = { fg = colors.gold_soft },
  Keyword      = { fg = colors.gold, bold = true },
  Type         = { fg = colors.amber },
  Variable     = { fg = colors.blue_var },

  Identifier   = { fg = colors.blue_var },

  Error        = { fg = colors.orange, bg = colors.base00, bold = true },
  Debug        = { fg = colors.orange },

  Cursor       = { fg = colors.base00, bg = colors.base06 },
  Visual       = { bg = colors.base01 },

  LineNr       = { fg = colors.base02 },
  CursorLineNr = { fg = colors.gold, bold = true },

  StatusLine   = { fg = colors.base05, bg = colors.base01 },
  VertSplit    = { fg = colors.base02 },

  Pmenu        = { fg = colors.base05, bg = colors.base01 },
  PmenuSel     = { fg = colors.base00, bg = colors.gold },

  Search       = { fg = colors.base00, bg = colors.amber },

  TabLine     = { fg = colors.base03, bg = colors.base01 },
  TabLineSel  = { fg = colors.gold, bg = colors.base02, bold = true },
  TabLineFill = { bg = colors.base01 },
}

for group, settings in pairs(highlight_groups) do
  local command = "highlight " .. group
  if settings.fg then command = command .. " guifg=" .. settings.fg end
  if settings.bg then command = command .. " guibg=" .. settings.bg end
  if settings.bold then command = command .. " gui=bold" end
  if settings.italic then command = command .. " gui=italic" end
  vim.cmd(command)
end
-- vim.cmd("highlight clear")
-- vim.cmd("syntax reset")
-- vim.g.colors_name = "dwf"
--
-- local colors = {
--   base00 = "#22303C",
--     base01 = "#3B4A56",
--     base02 = "#56636F",
--   base03 = "#415A77",
--   base04 = "#6C7A89",
--   base05 = "#E6D5B8",
--   base06 = "#CFC8B5",
--   base07 = "#ECE6D8",
--   base08 = "#CC6E2E",
--   base09 = "#C79A2B",
--   base0A = "#DDAA33",
--   base0B = "#B68A3A",
--   base0C = "#CD7F32",
--   base0D = "#415A77",
--   base0E = "#B8860B",
--   base0F = "#A65A2E",
-- }
--
-- local highlight_groups = {
--   Normal       = { fg = colors.base05, bg = colors.base00 },
--   Comment      = { fg = colors.base03, italic = true },
--   Constant     = { fg = colors.base0C },
--   String       = { fg = colors.base0B },
--   Function     = { fg = colors.base09 },
--   Keyword      = { fg = colors.base0A, bold = true },
--   Type         = { fg = colors.base0E },
--   Variable     = { fg = colors.base0D },
--   Error        = { fg = colors.base08, bg = colors.base00, bold = true },
--   Debug        = { fg = colors.base0F },
--   Cursor       = { fg = colors.base00, bg = colors.base06 },
--   Visual       = { bg = colors.base01 },
--   LineNr       = { fg = colors.base02 },
--   CursorLineNr = { fg = colors.base04, bold = true },
--   StatusLine   = { fg = colors.base05, bg = colors.base01 },
--   VertSplit    = { fg = colors.base02 },
--   Pmenu        = { fg = colors.base05, bg = colors.base01 },
--   PmenuSel     = { fg = colors.base00, bg = colors.base0A },
--   Search       = { fg = colors.base00, bg = colors.base0A },
--
--   TabLine     = { fg = colors.base03, bg = colors.base01 },
--   TabLineSel  = { fg = colors.base0A, bg = colors.base02, bold = true },
--   TabLineFill = { bg = colors.base01 },
-- }
--
-- for group, settings in pairs(highlight_groups) do
--   local command = "highlight " .. group
--   if settings.fg then command = command .. " guifg=" .. settings.fg end
--   if settings.bg then command = command .. " guibg=" .. settings.bg end
--   if settings.bold then command = command .. " gui=bold" end
--   if settings.italic then command = command .. " gui=italic" end
--   vim.cmd(command)
-- end
