# encoding: UTF-8
require 'rubygems'
require 'bundler/gem_tasks'

require 'rake'
require 'rdoc/task'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :env do
  $: << File.expand_path('lib', File.dirname(__FILE__))
  require 'to_spreadsheet'
  include HtmlToXlsx::Helpers
end
