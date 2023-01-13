#!/usr/bin/env ruby

require_relative '../config/boot'

cmd = Glimte::Dev::WatchSceneCommand.new
cmd.run

Glimte::Dev::Scene.watch(cmd.params[:scene])
