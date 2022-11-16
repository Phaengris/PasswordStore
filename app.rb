require_relative './config/boot'

Tk.tk_call('source', Framework.path('app/assets/tk/azure/azure.tcl'))
Tk.tk_call('set_theme', 'dark')

# settings_window = Views.settings_window
Views.main_window {
  # on('SettingsWindowCalled') {
  #   settings_window.open
  # }
}.open