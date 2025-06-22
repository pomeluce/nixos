local monokai = {
  background = '#273136',
  foreground = '#fdf9f3',
  dark = '#363537',
  text = '#ffffff',
  black = '#908e8f',
  red = '#ff6d7e',
  green = '#a2e57b',
  yellow = '#ffed72',
  oragen = '#ffb270',
  purple = '#baa0f8',
  cyan = '#7cd5f1',
  white = '#fdf9f3',
}

return {
  background = monokai.background,
  foreground = monokai.foreground,
  cursor_bg = monokai.white,
  cursor_border = monokai.white,
  cursor_fg = monokai.dark,
  ansi = {
    monokai.black,
    monokai.red,
    monokai.green,
    monokai.yellow,
    monokai.oragen,
    monokai.purple,
    monokai.cyan,
    monokai.white,
  },
  brights = {
    monokai.black,
    monokai.red,
    monokai.green,
    monokai.yellow,
    monokai.oragen,
    monokai.purple,
    monokai.cyan,
    monokai.white,
  },

  tab_bar = {
    background = monokai.background,
    active_tab = {
      bg_color = monokai.background,
      fg_color = monokai.text,
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = monokai.background,
      fg_color = monokai.black,
      italic = true,
    },
    inactive_tab_hover = {
      bg_color = monokai.background,
      fg_color = monokai.foreground,
    },
    new_tab = {
      bg_color = monokai.background,
      fg_color = monokai.foreground,
    },
    new_tab_hover = {
      bg_color = monokai.background,
      fg_color = monokai.text,
      italic = true,
    },
  },
}
