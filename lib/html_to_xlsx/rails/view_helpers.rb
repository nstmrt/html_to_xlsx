module HtmlToXlsx
  module Rails
    module ViewHelpers
      def format_xls(selector = nil, &block)
        context = HtmlToXlsx::Context.current
        return unless context
        context.format_xls(selector, &block)
      end
    end
  end
end
