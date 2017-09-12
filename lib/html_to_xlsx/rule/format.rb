module HtmlToXlsx
  module Rule
    class Format < Base

      def apply(workbook, context, xls_ent)
        if self.options.is_a?(Proc)
          return if xls_ent.blank?
          context.instance_exec(xls_ent, &self.options)
          return
        end

        options = self.options.dup

        options.each do |k, v|
          options[k] = context.instance_exec(xls_ent, &v) if v.is_a?(Proc)
        end

        style = workbook.styles.add_style options
        cells = xls_ent.respond_to?(:cells) ? xls_ent.cells : [xls_ent]
        cells.each { |cell| cell.style = style }
      end
    end
  end
end
