require 'active_support/all' # TODO: cut to what we really need?
require 'glimmer-dsl-tk'
require 'pp'
require 'zeitwerk'

require_relative '../lib/framework'

Dir.glob(Framework.path('lib/core/**/*.rb')).each { |core_patch| load core_patch }
Dir.glob(Framework.path('lib/overrides/**/*.rb')).each { |override| load override }

loader = Zeitwerk::Loader.new

loader.push_dir(Framework.path('lib'))
loader.push_dir(Framework.path('app/models'))
loader.push_dir(Framework.path('app/views'), namespace: ViewModels)

loader.ignore(Framework.path('lib/core'))
loader.ignore(Framework.path('lib/overrides'))
loader.ignore(Framework.path('lib/framework/views.rb'))
loader.ignore(Framework.path('lib/framework/view_models.rb'))
loader.ignore(Framework.path('app/views/**/*.glimmer.rb'))

loader.enable_reloading # TODO: if <condition>?

loader.setup

# TODO: move into initializers/tk?

# Tk.tk_call('source', Framework.path('app/assets/tk/azure/azure.tcl'))
# Tk.tk_call('source', Framework.path('app/assets/tk/sun-valley/sv.tcl'))
# Tk.tk_call('set_theme', 'light')
# Tk.tk_call('set_theme', 'dark')

Tk.tk_call('source', Framework.path('app/assets/tk/forest/forest-light.tcl'))
Tk.tk_call('source', Framework.path('app/assets/tk/forest/forest-dark.tcl'))
Tk::Tile::Style.theme_use "forest-light"

Tk::Tile::Style.configure('Alert.TLabel', { "foreground" => "#FF3860" })
Tk::Tile::Style.configure('FlashAlert.TFrame', { "background" => "#FF3860" })
Tk::Tile::Style.configure('FlashAlert.TLabel', { "background" => "#FF3860", foreground: "#FFFFFF" })