module HtmlToXlsx
  module Rule
    class Container < Base
      attr_reader :children

      def initialize(*args)
        super
        @children = []
      end

      def to_s
        "Rules(#{selector_type}, #{selector_query}) [#{children.map(&:to_s)}]"
      end
    end
  end
end
