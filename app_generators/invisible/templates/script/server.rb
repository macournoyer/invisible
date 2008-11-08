#!/usr/bin/env ruby
exec "thin start -R config/boot.ru #{ARGV.join(' ')}"
