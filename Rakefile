require "spec/rake/spectask"
require "yaml"

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


gemspec = Gem::Specification.new do |s|
  s.name        = "invisible"
  s.version     = "0.0.1"
  s.date        = Time.today.strftime("%Y-%m-%d")
  s.summary     = "The Invisible Web Framework"
  s.email       = "macournoyer@gmail.com"
  s.homepage    = "http://github.com/macournoyer/invisible"
  s.description = "Invisible is like a giant robot combining the awesomeness of Rails, Merb, Camping and Sinatra. Except, it's tiny (100 sloc)."
  s.authors     = ["Marc-Andre Cournoyer"]
  s.files       = %w(README Rakefile invisible.gemspec) + Dir["{bin,lib,app_generators}/**/*"]
  
  # RDoc
  s.has_rdoc         = true
  s.rdoc_options     = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  
  # Dependencies
  s.add_dependency    "rack",    ">= 0.4.0"
  s.add_dependency    "markaby", ">= 0.5"
  
  # Binary
  s.bindir             = "bin"
  s.default_executable = "invisible"
  s.executables        = "invisible"
end

namespace :gem do
  desc "Update the gemspec for GitHub's gem server"
  task :github do
    File.open("invisible.gemspec", 'w') { |f| f << YAML.dump(gemspec) }
  end
end
