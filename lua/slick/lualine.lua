-- Slick: builds a lualine theme from a generated palette.
return function(name)
  local p = require("slick.palettes")[name]
  assert(p, "slick: unknown theme '" .. tostring(name) .. "'")

  local function mode(color)
    return {
      a = { fg = p.on_fill, bg = color, gui = "bold" },
      b = { fg = p.muted, bg = p.element },
      c = { fg = p.placeholder, bg = p.bg },
    }
  end

  return {
    normal = mode(p.accent),
    insert = mode(p.green),
    visual = mode(p.magenta),
    replace = mode(p.red),
    command = mode(p.yellow),
    terminal = mode(p.cyan),
    inactive = {
      a = { fg = p.placeholder, bg = p.bg },
      b = { fg = p.placeholder, bg = p.bg },
      c = { fg = p.placeholder, bg = p.bg },
    },
  }
end
