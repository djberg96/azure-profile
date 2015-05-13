require 'rake'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include('**/*.tar', '**/*.zip', '**/*.gz', '**/*.bz2')
CLEAN.include('**/*.rbc', '**/*.gem', '**/*.tmp')

namespace 'gem' do
  desc 'Create the azure-profile gem'
  task :create => [:clean] do
    require 'rubygems/package'
    spec = eval(IO.read('azure-profile.gemspec'))
    Gem::Package.build(spec)
  end

  desc 'Install the azure-profile gem'
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
  end
end

Rake::TestTask.new do |t|
  t.test_files = ['spec/*.rb']
  t.verbose = true
  t.warning = true
end

task :default => :test
