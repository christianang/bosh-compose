#!/usr/bin/env ruby
# Add lib to load path
$:.unshift File.expand_path("../lib", File.dirname(__FILE__))

require 'compose'

puts Compose::Renderer.new().render(ARGV[0], ARGV[1])

