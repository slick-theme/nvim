-- Slick: loads a generated palette and applies its highlight groups.
local M = {}

local function slug(name)
  return (name:lower():gsub("[^a-z0-9]+", "-"):gsub("^-", ""):gsub("-$", ""))
end

function M.load(name)
  local p = require("slick.palettes")[name]
  assert(p, "slick: unknown theme '" .. tostring(name) .. "'")

  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = p.mode
  vim.g.colors_name = "slick-" .. slug(name)

  local function hl(group, spec)
    vim.api.nvim_set_hl(0, group, spec)
  end

  local groups = {
    -- Editor
    Normal = { fg = p.fg, bg = p.bg },
    NormalNC = { fg = p.fg, bg = p.bg },
    NormalFloat = { fg = p.fg, bg = p.bg },
    FloatBorder = { fg = p.border, bg = p.bg },
    FloatTitle = { fg = p.accent, bg = p.bg, bold = true },
    Cursor = { fg = p.bg, bg = p.accent },
    CursorLine = { bg = p.hover },
    CursorColumn = { bg = p.hover },
    ColorColumn = { bg = p.element },
    LineNr = { fg = p.line_nr },
    CursorLineNr = { fg = p.accent, bg = p.hover },
    SignColumn = { fg = p.line_nr, bg = p.bg },
    FoldColumn = { fg = p.line_nr, bg = p.bg },
    Folded = { fg = p.muted, bg = p.element },
    VertSplit = { fg = p.border },
    WinSeparator = { fg = p.border },
    EndOfBuffer = { fg = p.bg },
    NonText = { fg = p.punctuation },
    Whitespace = { fg = p.punctuation },
    SpecialKey = { fg = p.punctuation },
    Conceal = { fg = p.placeholder },
    Directory = { fg = p.blue },
    Title = { fg = p.magenta, bold = true },
    MatchParen = { bg = p.selection, bold = true },
    Visual = { bg = p.selection },
    VisualNOS = { bg = p.selection },
    Search = { bg = p.search },
    CurSearch = { fg = p.on_fill, bg = p.accent },
    IncSearch = { fg = p.on_fill, bg = p.accent },
    Substitute = { fg = p.on_fill, bg = p.accent },
    QuickFixLine = { bg = p.active },
    WildMenu = { fg = p.on_fill, bg = p.accent },

    -- Chrome
    StatusLine = { fg = p.muted, bg = p.bg },
    StatusLineNC = { fg = p.placeholder, bg = p.bg },
    TabLine = { fg = p.placeholder, bg = p.bg },
    TabLineFill = { bg = p.bg },
    TabLineSel = { fg = p.fg, bg = p.bg, bold = true },
    WinBar = { fg = p.muted, bg = p.bg },
    WinBarNC = { fg = p.placeholder, bg = p.bg },
    Pmenu = { fg = p.fg, bg = p.bg },
    PmenuSel = { fg = p.fg, bg = p.active },
    PmenuSbar = { bg = p.element },
    PmenuThumb = { bg = p.accent },
    MsgArea = { fg = p.fg, bg = p.bg },
    MoreMsg = { fg = p.ok },
    ModeMsg = { fg = p.muted },
    Question = { fg = p.accent },
    ErrorMsg = { fg = p.error },
    WarningMsg = { fg = p.warn },
    SpellBad = { sp = p.error, undercurl = true },
    SpellCap = { sp = p.warn, undercurl = true },
    SpellLocal = { sp = p.info, undercurl = true },
    SpellRare = { sp = p.hint, undercurl = true },

    -- Syntax
    Comment = { fg = p.comment },
    Constant = { fg = p.blue },
    String = { fg = p.cyan },
    Character = { fg = p.cyan },
    Number = { fg = p.red },
    Boolean = { fg = p.red },
    Float = { fg = p.red },
    Identifier = { fg = p.muted },
    Function = { fg = p.yellow },
    Statement = { fg = p.magenta },
    Conditional = { fg = p.magenta },
    Repeat = { fg = p.magenta },
    Label = { fg = p.emerald },
    Operator = { fg = p.punctuation },
    Keyword = { fg = p.magenta },
    Exception = { fg = p.magenta },
    PreProc = { fg = p.magenta },
    Include = { fg = p.magenta },
    Define = { fg = p.magenta },
    Macro = { fg = p.magenta },
    PreCondit = { fg = p.magenta },
    Type = { fg = p.green },
    StorageClass = { fg = p.magenta },
    Structure = { fg = p.green },
    Typedef = { fg = p.green },
    Special = { fg = p.yellow },
    SpecialChar = { fg = p.red },
    Tag = { fg = p.green },
    Delimiter = { fg = p.punctuation },
    SpecialComment = { fg = p.emerald },
    Debug = { fg = p.red },
    Underlined = { fg = p.cyan, underline = true },
    Ignore = { fg = p.placeholder },
    Error = { fg = p.error },
    Todo = { fg = p.on_fill, bg = p.accent, bold = true },
    Added = { fg = p.added },
    Changed = { fg = p.changed },
    Removed = { fg = p.removed },

    -- Treesitter
    ["@variable"] = { fg = p.muted },
    ["@variable.builtin"] = { fg = p.blue },
    ["@variable.parameter"] = { fg = p.muted },
    ["@variable.member"] = { fg = p.fg },
    ["@constant"] = { fg = p.blue },
    ["@constant.builtin"] = { fg = p.blue },
    ["@module"] = { fg = p.green },
    ["@label"] = { fg = p.emerald },
    ["@string"] = { fg = p.cyan },
    ["@string.regexp"] = { fg = p.emerald },
    ["@string.escape"] = { fg = p.red },
    ["@string.special"] = { fg = p.emerald },
    ["@string.special.url"] = { fg = p.cyan, underline = true },
    ["@character"] = { fg = p.cyan },
    ["@boolean"] = { fg = p.red },
    ["@number"] = { fg = p.red },
    ["@type"] = { fg = p.green },
    ["@type.builtin"] = { fg = p.green },
    ["@attribute"] = { fg = p.fg },
    ["@property"] = { fg = p.fg },
    ["@function"] = { fg = p.yellow },
    ["@function.builtin"] = { fg = p.yellow },
    ["@function.macro"] = { fg = p.magenta },
    ["@constructor"] = { fg = p.green },
    ["@operator"] = { fg = p.punctuation },
    ["@keyword"] = { fg = p.magenta },
    ["@keyword.operator"] = { fg = p.magenta },
    ["@punctuation"] = { fg = p.punctuation },
    ["@punctuation.special"] = { fg = p.yellow },
    ["@comment"] = { fg = p.comment },
    ["@comment.documentation"] = { fg = p.emerald },
    ["@comment.error"] = { fg = p.error, bold = true },
    ["@comment.warning"] = { fg = p.warn, bold = true },
    ["@comment.todo"] = { fg = p.on_fill, bg = p.accent, bold = true },
    ["@comment.note"] = { fg = p.info, bold = true },
    ["@tag"] = { fg = p.green },
    ["@tag.attribute"] = { fg = p.fg },
    ["@tag.delimiter"] = { fg = p.punctuation },
    ["@markup.strong"] = { fg = p.cyan, bold = true },
    ["@markup.italic"] = { fg = p.cyan, italic = true },
    ["@markup.heading"] = { fg = p.magenta },
    ["@markup.link"] = { fg = p.blue },
    ["@markup.link.url"] = { fg = p.cyan, underline = true },
    ["@markup.raw"] = { fg = p.cyan },
    ["@markup.quote"] = { fg = p.punctuation },
    ["@markup.list"] = { fg = p.punctuation },
    ["@diff.plus"] = { fg = p.added },
    ["@diff.minus"] = { fg = p.removed },
    ["@diff.delta"] = { fg = p.changed },

    -- LSP
    LspReferenceText = { bg = p.element },
    LspReferenceRead = { bg = p.element },
    LspReferenceWrite = { bg = p.active },
    LspInlayHint = { fg = p.placeholder, bg = p.element },
    LspCodeLens = { fg = p.placeholder },
    ["@lsp.type.parameter"] = { fg = p.muted },
    ["@lsp.type.property"] = { fg = p.fg },
    ["@lsp.type.enumMember"] = { fg = p.blue },

    -- Diagnostics
    DiagnosticError = { fg = p.error },
    DiagnosticWarn = { fg = p.warn },
    DiagnosticInfo = { fg = p.info },
    DiagnosticHint = { fg = p.hint },
    DiagnosticOk = { fg = p.ok },
    DiagnosticVirtualTextError = { fg = p.error, bg = p.error_bg },
    DiagnosticVirtualTextWarn = { fg = p.warn, bg = p.warn_bg },
    DiagnosticVirtualTextInfo = { fg = p.info, bg = p.info_bg },
    DiagnosticVirtualTextHint = { fg = p.hint, bg = p.hint_bg },
    DiagnosticUnderlineError = { sp = p.error, undercurl = true },
    DiagnosticUnderlineWarn = { sp = p.warn, undercurl = true },
    DiagnosticUnderlineInfo = { sp = p.info, undercurl = true },
    DiagnosticUnderlineHint = { sp = p.hint, undercurl = true },

    -- Diff and git
    DiffAdd = { bg = p.diff_add },
    DiffChange = { bg = p.diff_change },
    DiffDelete = { bg = p.diff_delete },
    DiffText = { bg = p.diff_text },
    diffAdded = { fg = p.added },
    diffChanged = { fg = p.changed },
    diffRemoved = { fg = p.removed },
  }

  local plugins, links = require("slick.plugins").groups(p)
  for group, spec in pairs(plugins) do
    groups[group] = spec
  end

  for group, spec in pairs(groups) do
    hl(group, spec)
  end

  for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end

  -- Terminal colours 0-15
  for i, color in ipairs(p.ansi) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
  vim.g.terminal_color_background = p.bg
  vim.g.terminal_color_foreground = p.fg
end

return M
