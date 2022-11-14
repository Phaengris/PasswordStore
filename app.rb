require_relative './config/boot'

Tk.tk_call('source', Framework.path('app/assets/tk/azure/azure.tcl'))
Tk.tk_call('set_theme', 'dark')

Views.main_window.open