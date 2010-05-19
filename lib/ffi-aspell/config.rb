module Aspell::Interface

  class KeyInfo < FFI::Struct
    TYPE = FFI::Enum.new [:AspellKeyInfoString, :AspellKeyInfoInt,
                          :AspellKeyInfoBool, :AspellKeyInfoList]

    layout :name,       :string,
           :type,       TYPE,
           :def,        :string,
           :desc,       :string,
           :flags,      :int,
           :other_data, :int


    module Enumeration; protected
    extend Aspell::Interface

      scope :aspell_key_info_enumeration do
        fn :_at_end,  pointer(Enumeration) => int(:success)
        fn :_next,    pointer(Enumeration) => pointer(KeyInfo)
        fn :delete_,  pointer(Enumeration)
        fn :_clone,   pointer(Enumeration) => pointer(Enumeration)
        fn :_assign,  pointer(Enumeration),
                          pointer(:other => Enumeration)
      end

    end
  end

  class StringPair < FFI::Struct
    layout :first, :string,
           :second, :string

    module Enumeration; protected
    extend Aspell::Interface

      scope :aspell_string_pair_enumeration do
        fn :_at_end,  pointer(Enumeration) => int(:success)
        fn :_next,    pointer(Enumeration) => pointer(StringPair)
        fn :delete_,  pointer(Enumeration)
        fn :_clone,   pointer(Enumeration) => pointer(Enumeration)
        fn :_assign,  pointer(Enumeration),
                          pointer(:other => Enumeration)
      end

    end
  end

  module MutableContainer; protected
  extend Aspell::Interface

    scope :aspell_mutable_container do
      fn :_add,     pointer(MutableContainer), string(:key) => int(:success)
      fn :_remove,  pointer(MutableContainer), string(:key) => int(:success)
      fn :_clear,   pointer(MutableContainer)
      fn :_to_mutable_container,
                    pointer(MutableContainer) => pointer(MutableContainer)
    end

  end

  module Config; protected
  extend Aspell::Interface

    scope :aspell_config do
      fn :new_ =>   pointer(Config)
      fn :delete_,  pointer(Config)
      fn :_clone,   pointer(Config) => pointer(Config)
      fn :_assign,  pointer(Config), pointer(Config)

      fn :_error_number,  pointer(Config) => :uint
      fn :_error_message, pointer(Config) => :string
      fn :_error,         pointer(Config) => pointer(Error)

      # Sets extra keys which this config class should accept. begin and end
      # are expected to point to the beginning and ending of an array of
      # Aspell Key Info.
      fn :_set_extra, pointer(Config),
          pointer(:begin => KeyInfo), pointer(:end => KeyInfo)

      # Returns the KeyInfo object for the corresponding key or returns NULL
      # and sets error_num to PERROR_UNKNOWN_KEY if the key is not valid. The
      # pointer returned is valid for the lifetime of the object.
      fn :_keyinfo, pointer(Config), string(:key) => pointer(KeyInfo)

      # Returns a newly allocated enumeration of all the possible objects this
      # config class uses.
      fn :_possible_elements, pointer(Config),
          int(:include_extras) => pointer(KeyInfo::Enumeration)

      # Returns the default value for given key which may involve substituting
      # variables, thus it is not the same as keyinfo(key)->def returns NULL
      # and sets error_num to PERROR_UNKNOWN_KEY if the key is not valid. Uses
      # the temporary string.
      fn :_get_default, pointer(Config), string(:key) => :string

      # Returns a newly allocated enumeration of all the key/value pairs. This
      # DOES not include ones which are set to their default values.
      fn :_elements, pointer(Config) => pointer(StringPair::Enumeration)

      # Inserts an item, if the item already exists it will be replaced.
      # Returns TRUE if it succeeded or FALSE on error. If the key is not
      # valid it sets error_num to PERROR_UNKNOWN_KEY, if the value is not
      # valid it will set error_num to PERROR_BAD_VALUE, if the value can not
      # be changed it sets error_num to PERROR_CANT_CHANGE_VALUE, and if the
      # value is a list and you are trying to set its directory, it sets
      # error_num to PERROR_LIST_SET
      fn :_replace, pointer(Config),
          string(:key), string(:value) => :bool

      # Remove a key and returns TRUE if it exists otherwise return FALSE.
      # This effectively sets the key to its default value. Calling replace
      # with a value of "<default>" will also call remove. If the key does not
      # exist then it sets error_num to 0 or PERROR_NOT, if the key is not
      # valid then it sets error_num to PERROR_UNKNOWN_KEY, if the value can
      # not be changed then it sets error_num to PERROR_CANT_CHANGE_VALUE
      fn :_remove, pointer(Config), string(:key) => int(:success)

      fn :_have, pointer(Config), string(:key) => int(:success)

      fn :_retrieve,      pointer(Config), string(:key) => :string
      fn :_retrieve_list, pointer(Config), string(:key),
                              pointer(MutableContainer) => :int

      # In "ths" Aspell configuration, search for a character string matching
      # "key" string.
      fn :_retrieve_bool, pointer(Config), string(:key_match) => int(:success)

      # In "ths" Aspell configuration, search for an integer value matching
      # "key" string.
      fn :_retrieve_int,  pointer(Config), string(:key_match) => int(:success)
    end

  end
end
