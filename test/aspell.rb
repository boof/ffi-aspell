require 'rubygems'

$-w = true
$-d = true

$: << File.join(File.dirname(__FILE__), '..', 'lib')
require 'ffi-aspell'

module Aspell

  def self.require(files)
    files.each { |file| super __FILE__.insert(-4, "/#{ file }") }
  end

  require %w[ config speller ]

end

if $-d
  puts 'Aspell::Interface::'
  puts Aspell::Interface.inspect
end

config = Aspell::Config.new

begin
  config[:bar] = :baz
  raise
rescue => e
  IndexError === e or
  raise RuntimeError, "expected IndexError, got #{ e.class }"
  e.message == 'The key "bar" is unknown.' or
  raise RunetimeError 'expected key "bar" to be unknown'
end

config.each { |k, v| puts k, v }
