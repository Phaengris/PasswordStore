require 'tty-option'

class Framework::Dev::ConsoleCommand
  include TTY::Option

  usage do
    no_command
    desc "Run application in \"console\" mode"
    example "console"
    example "console \"Views.MainWindow.open\""
    example "echo \"Views.MainWindow.open\" | console"
  end

  argument :script do
    optional
    desc <<DESC.strip
A string to evaluate. If provided, interactive mode isn't started, but the script is evaluated and the output is printed.
Passing a string through pipeline is processed the same way.
DESC
  end

  option :help do
    short '-h'
    long '--help'
    desc "Print usage"
  end

  def run
    parse

    case
    when params[:help]
      puts help
      exit 0
    when !params.valid?
      puts params.errors.summary
      exit 1
    end
  end

end