module Aspell::Interface

  class WordList < FFI::Struct
  end

  module Speller; protected
  extend Aspell::Interface

    scope :aspell_speller do
      fn :new_, pointer(Config) => pointer(CanHaveError)
      fn :to_, pointer(CanHaveError) => pointer(Speller)
      fn :delete_, pointer(Speller)
      fn :_error_number, pointer(Speller) => :uint
      fn :_error_message, pointer(Speller) => :string
      fn :_error, pointer(Speller) => pointer(Error)
      fn :_config, pointer(Speller) => pointer(Config)

      fn :_check, pointer(Speller),
          string(:word), int(:length) => int(:success)

      fn :_add_to_personal, pointer(Speller),
          string(:word), int(:length) => int(:success)
      fn :_add_to_session, pointer(Speller),
          string(:word), int(:length) => int(:success)

      # This is your own personal word list file plus any extra words added
      # during this session to your own personal word list.
      fn :_personal_word_list, pointer(Speller) => pointer(WordList)

      # This is a list of words added to this session that are not in the main
      # word list or in your own personal list but are considered valid for
      # this spelling session.
      fn :_session_word_list, pointer(Speller) => pointer(WordList)

      # This is the main list of words used during this spelling session.
      fn :_main_word_list, pointer(Speller) => pointer(WordList)

      fn :_save_all_word_lists, pointer(Speller) => int(:success)
      fn :_clear_session, pointer(Speller) => int(:success)

      # Return NULL on error.
      #
      # The word list returned by suggest is only valid until the next call to
      # suggest.
      fn :_suggest, pointer(Speller),
          string(:word), int(:length) => pointer(WordList)

      fn :_store_replacement, pointer(Speller),
          string(:mis), int(:mis_length),
          string(:cor), int(:cor_length) => int(:success)
    end

  end
end
