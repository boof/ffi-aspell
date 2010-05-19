class Aspell::Config
  include Aspell::Interface::Config
  include Aspell::Interface::StringPair::Enumeration

  def initialize
    @pointer = new_aspell_config
    at_exit { delete_aspell_config @pointer }
  end

  def [](key)
    value = aspell_config_retrieve @pointer, key.to_s
    value || default(key)
  end

  def fetch(key, *args)
    args.empty? or args.length == 1 or
    raise ArgumentError, "wrong number of arguments (#{ args.length } for 2)"

    value = aspell_config_retrieve @pointer, key.to_s
    raise IndexError, 'key not found' if value.nil? and args.empty?

    value || args.first
  end

  def []=(key, value)
    unless aspell_config_replace(@pointer, key.to_s, value.to_s)
      p_error = aspell_config_error @pointer
      error = Aspell::Interface::Error.new p_error
      raise error[:mesg]
    end
  end

  def each
    p_elements = aspell_config_elements @pointer
    return unless p_elements.address > 0

    begin
      while aspell_string_pair_enumeration_at_end(p_elements) != 0
        p_pair = aspell_string_pair_enumeration_next p_elements
        pair = Aspell::Interface::StringPair.new p_pair

        yield pair[:first], pair[:second]
      end
    ensure
      delete_aspell_string_pair_enumeration p_elements
    end
  end

  def default(key)
    aspell_config_get_default @pointer, key.to_s
  end

end
