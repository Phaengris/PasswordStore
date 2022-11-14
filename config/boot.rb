require 'active_support/all' # TODO: cut to what we really need?
require 'glimmer-dsl-tk'
require 'pp'
require 'zeitwerk'

require_relative '../lib/framework'

Dir.glob(Framework.path('lib/core/*')).each { |core_patch| require core_patch }

loader = Zeitwerk::Loader.new

loader.push_dir(Framework.path('lib'))
loader.push_dir(Framework.path('app/models'))
loader.push_dir(Framework.path('app/views'), namespace: ViewModels)

loader.ignore(Framework.path('lib/core'))
loader.ignore(Framework.path('lib/framework/views.rb'))
loader.ignore(Framework.path('lib/framework/view_models.rb'))
loader.ignore(Framework.path('app/views/**/*.glim.rb'))

loader.setup
