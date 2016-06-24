require 'rubygems'

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-lint/tasks/puppet-lint'
require 'rubocop/rake_task'

Rake::Task[:lint].clear
Rake::Task[:default].clear

PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ['spec/**/*.pp', 'pkg/**/*.pp', 'vendor/**/*.pp']
end

desc 'Validate manifests, templates, and ruby files'
task :validate do
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

PuppetSyntax.exclude_paths = ['spec/**/*', 'pkg/**/*', 'vender/**/*']
PuppetSyntax.hieradata_paths = ['**/data/**/*.yaml', 'hieradata/**/*.yaml', 'hiera*.yaml']

task :default => [
  :lint,
  :syntax,
  :rubocop,
  :validate,
  :spec
]
