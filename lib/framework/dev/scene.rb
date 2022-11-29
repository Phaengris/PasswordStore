require 'listen'

class Framework::Dev::Scene
  include SingletonWithInstanceMethods

  class SceneNotFound < StandardError; end
  class SceneNotWatched < StandardError;
    def initialize(msg = "No dev scene is watched. Use Framework::Dev::Scene.watch to start watching a scene.")
      super
    end
  end
  class SceneAlreadyWatched < StandardError; end

  attr_internal_accessor :scene_path,
                         :scene_abs_path,
                         :scenarios,
                         :app_files_listener,
                         :app_files_changed

  def watch(scene_path)
    raise SceneAlreadyWatched, "Already watching #{self.scene_path}" if watched?

    self.scene_path = ActiveFile::Utils.clean_path(scene_path).delete_suffix('.rb')
    self.scene_abs_path = Framework.path('dev/scenes').join("#{self.scene_path}.rb")
    raise SceneNotFound, "Can't find scene file #{scene_abs_path}" unless File.exist?(scene_abs_path)
    unmemoize :watched?

    reload
  end

  memoize def watched?
    self.scene_path.present?
  end

  memoize def scenario_for(view_path)
    raise SceneNotWatched unless watched?

    view_path = view_path.to_s
    scenarios[view_path].blank? ? nil : scenarios[view_path].inject(proc {}, :<<)
  end

  def reload
    raise SceneNotWatched unless watched?

    unless File.exists?(scene_abs_path)
      puts "Can't continue watching, scene file #{scene_abs_path} has been lost"
      app_files_listener&.stop
      exit 1
    end

    scene_content = File.read(scene_abs_path)
    self.scenarios = SceneEvaluator.new(_scene_content: scene_content).instance_variable_get(:@_scenarios)
    if scenarios.blank?
      puts "Warning: No scenarios found in #{scene_abs_path}. Use scenario_for to add scenarios for views."
    end

    start_app_files_listener
    unmemoize :scenario_for
    if Views.main_window_ready?
      reload_main_window
    else
      Views.MainWindow.open
    end
  end

  def patch_glimmer_container(container)
    raise SceneNotWatched unless watched?

    container.content do
      container.instance_exec(&reload_shortcut_proc)
    end
  end

  private

  def start_app_files_listener
    app_files_listener&.stop
    self.app_files_changed = false
    # TODO: whole ./app tree?
    self.app_files_listener = Listen.to(Framework.path('app/models'),
                                        Framework.path('app/views')) do |modified, added, removed|
      unless app_files_changed
        puts "Notice: app files change detected, the app has to be reloaded"
        self.app_files_changed = true
      end

      puts "\"#{Time.now}\":"
      print_file_changes('modified', modified) if modified.any?
      print_file_changes('added', added) if added.any?
      print_file_changes('removed', removed) if removed.any?
    end
    app_files_listener.start
  end

  def print_file_changes(change_type, paths)
    puts "  #{change_type}"
    paths.each { |path| puts "    - #{path}"}
  end

  memoize def reload_shortcut_proc
    proc {
      on('KeyPress') { |event|
        if event.keysym.downcase == 'r' && event.state == 4
          Framework::Dev::Scene.reload
          break false
        end
      }
    }
  end

  def reload_main_window
    Views.MainWindow.children.each(&:destroy)
    Views.MainWindow.unbind_all

    template_path = Framework.path('app/views/main_window.glimmer.rb')
    raise Views::MainWindowTemplateNotFoundError unless File.exist?(template_path)

    view_model_path = Framework.path('app/views/main_window.rb')
    view_model_instance = ViewModels::MainWindow.new if File.exist?(view_model_path)

    Framework::TemplateEvaluator.new(_container: Views.MainWindow,
                                     _template_content: File.read(template_path),
                                     _view_model_name: 'main_window',
                                     _view_model_instance: view_model_instance,
                                     _body_block: scenario_for('main_window'))

    patch_glimmer_container(Views.MainWindow)
  end

  class SceneEvaluator
    def initialize(_scene_content:)
      @_scenarios = {}

      instance_eval(_scene_content)
    end

    def scenario_for(view_path, &block)
      @_scenarios[view_path] ||= []
      @_scenarios[view_path] << block
    end
  end

end