Tk.tk_call('source', Glimte.asset_path('tk/azure/azure.tcl'))
# Tk.tk_call('source', Glimte.asset_path('tk/sun-valley/sv.tcl'))
# Tk.tk_call('set_theme', 'light')
Tk.tk_call('set_theme', 'dark')

# Tk.tk_call('source', Glimte.asset_path('tk/forest/forest-light.tcl'))
# Tk.tk_call('source', Glimte.asset_path('tk/forest/forest-dark.tcl'))
# Tk::Tile::Style.theme_use "forest-light"

Tk::Tile::Style.configure('Alert.TLabel', { "foreground" => "#FF3860" })

Tk::Tile::Style.configure('FlashSuccess.TFrame', { "background" => "#23D160", foreground: "#FFFFFF" })
Tk::Tile::Style.configure('FlashSuccess.TLabel', { "background" => "#23D160", foreground: "#FFFFFF" })
Tk::Tile::Style.configure('FlashSuccessTimeout.TFrame', { "background" => "#00947E" })

Tk::Tile::Style.configure('FlashInfo.TFrame', { "background" => "#209CEE", foreground: "#FFFFFF" })
Tk::Tile::Style.configure('FlashInfo.TLabel', { "background" => "#209CEE", foreground: "#FFFFFF" })
Tk::Tile::Style.configure('FlashInfoTimeout.TFrame', { "background" => "#1D72AA" })

Tk::Tile::Style.configure('FlashAlert.TFrame', { "background" => "#FF3860", foreground: "#FFFFFF" })
Tk::Tile::Style.configure('FlashAlert.TLabel', { "background" => "#FF3860", foreground: "#FFFFFF" })
Tk::Tile::Style.configure('FlashAlertTimeout.TFrame', { "background" => "#CC0F35" })
