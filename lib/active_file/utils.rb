module ActiveFile::Utils
  class PathOutsideOfRoot < StandardError; end

  class << self

    # TODO: migrate to Pathname
    def clean_path(dirty_path)
      clean_path = []
      dirty_path.to_s.split('/').each do |part|
        case part
        when '', '.' then next
        when '..'
          raise PathOutsideOfRoot, "Path leads outside of root: #{dirty_path.pretty_print_inspect}" if clean_path.empty?
          clean_path.pop
        else
          clean_path << part
        end
      end
      clean_path.join('/')
    end

  end
end