require 'rake/clean'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

task default: [:rubocop, :spec]

CLOBBER.include %w(.rbx .yardoc coverage doc)

RSpec::Core::RakeTask.new
Rubocop::RakeTask.new
YARD::Rake::YardocTask.new

desc 'Generate coverage data'
task :coverage do
  ENV['SIMPLECOV'] = 'true'
  Rake::Task['spec'].invoke
end
