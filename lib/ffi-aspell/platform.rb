module Aspell

  unless defined? LIB_PATH
    bin = `which aspell`
    bin.chomp!

    unless bin.empty?
      dir = `#{ bin } config prefix`
      dir.chomp!

      LIB_PATH = Dir[ File.join(dir, 'lib', "libaspell.*") ].first
    else
      LIB_PATH = 'libaspell'
    end
  end

  module Interface
    def self.extended(base)
      base.extend FFI::Library
      base.ffi_lib Aspell::LIB_PATH
    end
  end

end
