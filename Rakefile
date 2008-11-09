require 'rake'
require 'rake/clean'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(-fs -c)
end

task :default => :spec

task :size do
  sloc = File.read("lib/invisible.rb").split("\n").reject { |l| l =~ /\s*\#/ }.size
  puts "#{sloc} sloc"
end