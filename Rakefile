#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

task :default => [:test,:spec]

Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
end
