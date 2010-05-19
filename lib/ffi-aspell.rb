require 'ffi'

module Aspell
  module Interface

    def self.require(files)
      files.each { |file| super __FILE__.insert(-4, "/#{ file }") }
    end

    require %w[ platform helper ]
    require %w[ error config speller ]

  end
end
