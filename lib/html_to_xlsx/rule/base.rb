module HtmlToXlsx
  module Rule
    class Base
      attr_reader :selector_type, :selector_query, :options

      def initialize(selector_type, selector_query, options)
        @selector_type  = selector_type
        @selector_query = selector_query
        @options = options
      end

      def type
        self.class.name.demodulize.underscore.to_sym
      end

      def to_s
        "Rule [#{type}, #{selector_type}, #{selector_query}, #{options}"
      end
    end
  end
end
