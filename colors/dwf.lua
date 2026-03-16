vim.cmd("highlight clear")
vim.cmd("syntax reset")
vim.g.colors_name = "dwf"

local colors = {

    -- Structural Base
    base00 = "#22303C",
    base01 = "#1B263B",
    base02 = "#2E3C48",
    base03 = "#415A77",
    base04 = "#6C7A89",

    -- Mineral Neutral
    base05 = "#E6D5B8",
    base06 = "#CFC8B5",
    base07 = "#ECE6D8",

    -- Energy (industrial orange)
    energy = "#CC6E2E",
    energy_bright = "#F05A22",

    -- Tech highlight
    tech = "#48C4F8",
    tech_alt = "#00D2C3",

    -- Mineral metallic accent
    mineral = "#C28840",
}

local highlight_groups = {

    Normal       = { fg = colors.base05, bg = colors.base00 },

    Comment      = { fg = colors.base03, italic = true },

    Constant     = { fg = colors.tech },
    String       = { fg = colors.tech_alt },

    Function     = { fg = colors.energy_bright, bold = true },

    Keyword      = { fg = colors.energy },

    Type         = { fg = colors.tech },

    Variable     = { fg = colors.base04 },
    Identifier   = { fg = colors.base04 },

    Error        = { fg = colors.energy_bright, bg = colors.base01, bold = true },

    Debug        = { fg = colors.energy },

    Cursor       = { fg = colors.base00, bg = colors.base06 },

    Visual       = { bg = colors.base01 },

    LineNr       = { fg = colors.base02 },
    CursorLineNr = { fg = colors.base04, bold = true },

    StatusLine   = { fg = colors.base05, bg = colors.base01 },

    VertSplit    = { fg = colors.base02 },

    Pmenu        = { fg = colors.base05, bg = colors.base01 },
    PmenuSel     = { fg = colors.base00, bg = colors.base04 },

    Search       = { fg = colors.base00, bg = colors.energy },

    TabLine      = { fg = colors.base03, bg = colors.base01 },
    TabLineSel   = { fg = colors.energy, bg = colors.base02, bold = true },
    TabLineFill  = { bg = colors.base01 },
}

for group, settings in pairs(highlight_groups) do
    local command = "highlight " .. group
    if settings.fg then command = command .. " guifg=" .. settings.fg end
    if settings.bg then command = command .. " guibg=" .. settings.bg end
    if settings.bold then command = command .. " gui=bold" end
    if settings.italic then command = command .. " gui=italic" end
    vim.cmd(command)
end
