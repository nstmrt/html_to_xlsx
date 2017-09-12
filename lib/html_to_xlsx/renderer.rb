require 'axlsx'
require 'nokogiri'

module HtmlToXlsx
  module Renderer
    extend self

    TYPE_ELEMENT = 1
    TYPE_END_ELEMENT = 15

    def to_stream(html, context = nil)
      to_package(html, context).to_stream
    end

    def to_data(html, context = nil)
      to_package(html, context).to_stream.read
    end

    def to_package(html, context = nil)
      context ||= HtmlToXlsx::Context.global.merge(Context.new)
      rules = rules_from_context(context)

      package = build_package(html, context, rules)

      package
    end

    private

    def rules_from_context(context)
      rules = []

      context.rules.each do |rule|
        if rule.is_a?(HtmlToXlsx::Rule::Container)
          rule.children.each do |child_rule|
            rules << child_rule
          end
        else
          rules << rule
        end
      end

      rules
    end

    def apply_rules(rules, context, workbook, node, xlsx_entity, selector = nil)
      rules.each do |rule|
        next if selector && !rule.selector_query.include?(selector)
        next unless node.matches?(rule.selector_query)

        rule.apply(workbook, context, xlsx_entity)
      end
    end

    def build_package(html, context, rules)
      package     = ::Axlsx::Package.new
      spreadsheet = package.workbook
      reader = Nokogiri::XML::Reader(html.chop)

      current_sheet = nil
      current_sheet_index = 0
      current_row = nil

      reader.each do |reader_el|
        if reader_el.name == 'table'

          node = Nokogiri::XML(reader_el.outer_xml).css('table').first

          if reader_el.node_type == TYPE_ELEMENT
            current_sheet_index += 1

            name = node.css('caption').inner_text.presence ||
                   node['name'] ||
                   "Sheet #{current_sheet_index}"
            current_sheet = spreadsheet.add_worksheet(name: name)
          else
            apply_rules(rules, context, spreadsheet, node, current_sheet, 'table')
          end
        end

        if reader_el.name == 'tr'
          if reader_el.node_type == TYPE_ELEMENT
            current_row = current_sheet.add_row
          else
            node = Nokogiri::XML(reader_el.outer_xml).css('tr').first
            apply_rules(rules, context, spreadsheet, node, current_row, 'tr')
          end
        end

        if (reader_el.name == 'th' || reader_el.name == 'td') && reader_el.node_type == TYPE_ELEMENT
          node = Nokogiri::XML(reader_el.outer_xml).css(reader_el.name).first
          cell = current_row.add_cell(node.inner_text)
          apply_rules(rules, context, spreadsheet, node, cell)
        end
      end
      package
    end
  end
end
