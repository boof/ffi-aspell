module Aspell::Interface

  ATTACHED_FUNCTIONS = Hash.new { |h, k| h[k] = [] }
  def self.[]=(mod, sig)
    ATTACHED_FUNCTIONS[mod] << sig
  end
  def self.inspect
    ATTACHED_FUNCTIONS.map { |(mod, sigs)|
      mod = mod.to_s.sub 'Aspell::Interface::', ''
      sigs.map { |(type, name, args)|
        #call = ":#{ name }, #{ args.inspect }, :#{ type.to_sym }"
        defn = "#{ name } #{ args * ', ' }"
        "#{ mod }##{ defn }"

        #{}"#{ mod }.attach_function #{ call }\n  # => #{ mod }##{ defn }"
      } * "\n"
    } * "\n"
  end

  class Scope < Struct.new(:interface, :name)
    class Type < Struct.new(:to_sym, :to_s)
      def self.string(desc)
        new :string, "String(#{ desc })"
      end
      def self.int(desc)
        new :int, "Fixnum(#{ desc })"
      end
      def self.pointer(type)
        desc, type = Hash === type ? type.to_a.flatten : [:pointer, type]
        type = type.to_s.sub 'Aspell::Interface::', ''
        new :pointer, "#{ type }.new(#{ desc })"
      end

      def inspect
        to_sym.inspect
      end
    end

    def complete_name(string)
      prefix = string if /_$/ =~ string
      suffix = string if /^_/ =~ string

      :"#{ prefix }#{ name }#{ suffix }"
    end
    def scope(object, &block)
      instance = self.class.new interface, complete_name(object.to_s)
      instance.instance_eval(&block) if block

      instance
    end
    def fn(*signature)
      args = extract_arguments(*signature.reverse)
      name = complete_name args.shift.to_s
      type = extract_type(*signature.reverse)

      Aspell::Interface[interface] = [type, name, args] if $-d

      interface.attach_function name,
          args.map { |arg| arg.to_sym }, type.to_sym
    end

    def int(desc) Type.int desc; end
    def string(desc) Type.string desc; end
    def pointer(desc) Type.pointer desc; end

    protected

      def extract_arguments(head, *tail)
        tail.reverse.push Hash === head ? head.keys.first : head
      end
      def extract_type(head, *tail)
        Hash === head ? head.values.last : :void
      end

  end

  def scope(name, &block)
    instance = Scope.new self, name
    instance.instance_eval(&block) if block_given?

    instance
  end

end
