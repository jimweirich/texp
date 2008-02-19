# -*- ruby -*-

require 'rake/clean'
require 'rake/testtask'

task :default => "test:units"

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
