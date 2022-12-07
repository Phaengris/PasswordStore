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
