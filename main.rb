require 'glimmer-dsl-tk'

Tk.tk_call('source', File.dirname(__FILE__) + '/assets/tk/sun-valley/sv.tcl')
# Tk.tk_call('source', File.dirname(__FILE__) + '/assets/tk/azure/azure.tcl')
Tk.tk_call('set_theme', 'dark')
# Tk.tk_call('set_theme', 'light')

Account.select('**/*.gpg').each do |account|
  pp account.basename
  pp account.password
end

# class App
#   include Glimmer
#
#   def launch
#     root do
#       width 400
#       height 400
#       frame {
#         button {
#           text 'Is it themed?'
#         }
#         checkbutton {
#           text 'And this one?'
#         }
#         entry {
#         }
#       }
#     end.open
#   end
#
# end
#
# App.new.launch
