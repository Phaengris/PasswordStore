#!/usr/bin/env ruby

require_relative '../config/boot'

cmd = Framework::Dev::WatchSceneCommand.new
cmd.run

Framework::Dev::Scene.watch(cmd.params[:scene])
