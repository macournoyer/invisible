require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(-fs -c)
end
task :default => :spec

desc "Compute LOC in invisible.rb"
task :size do
  loc = File.read("lib/invisible.rb").split("\n").reject { |l| l =~ /^\s*\#/ || l =~ /^\s*$/ }.size
  puts "#{loc} LOC"
end

namespace :site do
  task :build do
    mkdir_p 'tmp/site/images'
    cd 'tmp/site' do
      sh "SITE_ROOT='/invisible' ruby ../../site/thin.rb --dump"
    end
    cp 'site/style.css', 'tmp/site'
    cp_r Dir['site/images/*'], 'tmp/site/images'
  end
  
  desc 'Upload website to code.macournoyer.com'
  task :upload => :build do
    sh %{scp -rq tmp/site/* macournoyer@code.macournoyer.com:code.macournoyer.com/invisible}
    upload 'tmp/site/*', 'invisible'
  end
end
