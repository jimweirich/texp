# -*- ruby -*-

require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

$:.unshift 'lib'
require 'texp/version'
PACKAGE_VERSION = TExp::VERSION

CLEAN.include("*.tmp")
CLOBBER.include('coverage', 'rcov_aggregate')

task :default => "test:units"

task :version do
  puts "TExp Version #{PACKAGE_VERSION}"
end

namespace "test" do
  Rake::TestTask.new(:units) do |t|
    t.verbose = true
    t.test_files = FileList['test/**/*_test.rb']
  end
end
task :test_units => "test:units"

module Tags
  RUBY_FILES = FileList['**/*.rb']
  RUBY_FILES.include('**/*.rake')
end

namespace "tags" do
  desc "Generate an Emacs TAGS file"
  task :emacs => Tags::RUBY_FILES do
    puts "Making Emacs TAGS file"
    sh "xctags -e #{Tags::RUBY_FILES}", :verbose => false
  end
end

desc "Generate the TAGS file"
task :tags => ["tags:emacs"]

begin
  require 'rcov/rcovtask'

  Rcov::RcovTask.new do |t|
    t.libs << "test"
    t.rcov_opts = [
      '-xRakefile', '-xrakefile', '-xpublish.rf', '--text-report',
    ]
    t.test_files = FileList['test/**/*_test.rb']
    t.output_dir = 'coverage'
    t.verbose = true
  end
rescue LoadError
  puts "RCov is not available"
end

# RDoc Task
rd = Rake::RDocTask.new("rdoc") { |rdoc|
  rdoc.rdoc_dir = 'html'
  rdoc.template = 'doc/jamis.rb'
  rdoc.title    = "TExp - Temporal Expression Library for Ruby"
  rdoc.options << '--line-numbers' << '--inline-source' <<
    '--main' << 'README.rdoc' <<
    '--title' <<  'TExp - Temporal Expressions' 
  rdoc.rdoc_files.include('README.rdoc', 'MIT-LICENSE', 'ChangeLog')
  rdoc.rdoc_files.include('lib/**/*.rb', 'doc/**/*.rdoc')
}

# ====================================================================
# Create a task that will package the Rake software into distributable
# tar, zip and gem files.

PKG_FILES = FileList[
  '[A-Z]*',
  'lib/**/*.rb', 
  'test/**/*.rb',
  'doc/**/*'
]

if ! defined?(Gem)
  puts "Package Target requires RubyGEMs"
else
  spec = Gem::Specification.new do |s|
    s.name = 'texp'
    s.version = PACKAGE_VERSION
    s.summary = "Temporal Expressions for Ruby."
    s.description = <<-EOF
      TExp is a temporal expression library for Ruby with a modular, 
      extensible expression serialization language.
    EOF
    s.files = PKG_FILES.to_a
    s.require_path = 'lib'                         # Use these for libraries.
    s.has_rdoc = true
    s.extra_rdoc_files = rd.rdoc_files.reject { |fn| fn =~ /\.rb$/ }.to_a
    s.rdoc_options = rd.options
    s.author = "Jim Weirich"
    s.email = "jim.weirich@gmail.com"
    s.homepage = "http://texp.rubyforge.org"
    s.rubyforge_project = "texp"
  end

  package_task = Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_zip = true
    pkg.need_tar = true
  end
end

