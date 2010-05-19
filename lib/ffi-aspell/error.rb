module Aspell::Interface

  class ErrorInfo < FFI::Struct
    layout :isa,        :pointer, # to ErrorInfo
           :mesg,       :string,
           :num_params, :uint,
           :parms,      [:uint8, 3]
  end
  class Error < FFI::Struct
    layout :mesg, :string,
           :err,  :pointer # to ErrorInfo
  end

  module CanHaveError; protected
  extend Aspell::Interface

    scope :aspell do
      scope :_error do
        fn :_is_a,    pointer(Error), pointer(ErrorInfo) => int(:success)

        fn :_number,  pointer(CanHaveError) => :uint
        fn :_message, pointer(CanHaveError) => :string
      end

      fn :_error, pointer(CanHaveError) => pointer(Error)
      scope(:_can_have_error).fn :delete_, pointer(CanHaveError)
    end

  end
end
