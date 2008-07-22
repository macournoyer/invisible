require 'rake'
require 'rake/clean'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(-fs -c)
end

task :default => :spec

task :diff do
  abort "ERROR: parse_tree_show missing : `gem install ParseTree`" if `which parse_tree_show`.strip.empty?

  sh "parse_tree_show lib/invisible-block.rb > .invisible-block.pt"
  sh "parse_tree_show lib/invisible.rb > .invisible.pt"
  sh "diff -u .invisible-block.pt .invisible.pt"
  rm [".invisible-block.pt", ".invisible.pt"]
end

task :size do
  puts File.size("lib/invisible-block.rb")
end