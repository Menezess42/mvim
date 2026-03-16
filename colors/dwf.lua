vim.cmd("highlight clear")
vim.cmd("syntax reset")
vim.g.colors_name = "dwarfforge"

local colors = {

    -- Estrutura (aço / night steel)
    base00 = "#22303C",
    base01 = "#1B2630",
    base02 = "#2E3C48",
    base03 = "#415A77",
    base04 = "#6C7A89",

    -- Texto (metal claro)
    base05 = "#D8E1E8",
    base06 = "#E6EDF3",
    base07 = "#F2F6FA",

    -- Energia / forja
    base08 = "#CC6E2E", -- erro / alerta quente
    base09 = "#D9772A", -- ação / destaque
    base0A = "#C79A2B", -- dourado principal

    -- Dados
    base0B = "#2EC4B6", -- string / dados

    -- Interface técnica
    base0C = "#48C4F8", -- info / hint
    base0D = "#5E81AC", -- identifiers

    -- Tipos / estrutura
    base0E = "#B68A3A",

    -- Debug / raro
    base0F = "#A65A2E",
}

local highlight_groups = {

    Normal       = { fg = colors.base05, bg = colors.base00 },

    Comment      = { fg = colors.base03, italic = true },

    Constant     = { fg = colors.base0C },

    String       = { fg = colors.base0B },

    Function     = { fg = colors.base0A },

    Keyword      = { fg = colors.base0A, bold = true },

    Type         = { fg = colors.base0E },

    Variable     = { fg = colors.base05 },

    Identifier   = { fg = colors.base0D },

    Error        = { fg = colors.base08, bg = colors.base01, bold = true },

    Debug        = { fg = colors.base0F },

    Cursor       = { fg = colors.base00, bg = colors.base06 },

    Visual       = { bg = colors.base01 },

    LineNr       = { fg = colors.base02 },

    CursorLineNr = { fg = colors.base0A, bold = true },

    StatusLine   = { fg = colors.base05, bg = colors.base01 },

    VertSplit    = { fg = colors.base02 },

    Pmenu        = { fg = colors.base05, bg = colors.base01 },

    PmenuSel     = { fg = colors.base00, bg = colors.base0A },

    Search       = { fg = colors.base00, bg = colors.base09 },

    TabLine      = { fg = colors.base03, bg = colors.base01 },

    TabLineSel   = { fg = colors.base0A, bg = colors.base02, bold = true },

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
