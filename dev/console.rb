#!/usr/bin/env ruby

require_relative '../config/boot'

cmd = Glimte::Dev::ConsoleCommand.new
cmd.run

interactive_mode = true

if STDIN.stat.pipe?
  STDIN.each_line do |script|
    eval(script)
  end
  interactive_mode = false
end

unless ARGV.empty?
  ARGV.each do |script|
    eval(script)
  end
  exit 0
end

exit unless interactive_mode

require 'irb'

puts "Welcome to Framework console. Run with flag --help to get help about usage."
ARGV.clear
IRB.start
