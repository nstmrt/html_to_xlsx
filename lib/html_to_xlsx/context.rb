require 'html_to_xlsx/rule'

require 'html_to_xlsx/rule/base'
require 'html_to_xlsx/rule/container'
require 'html_to_xlsx/rule/format'

module HtmlToXlsx
  class Context
    attr_accessor :rules

    class << self
      def global
        @global ||= new
      end

      def current
        Thread.current[:_to_spreadsheet_ctx]
      end

      def current=(context)
        Thread.current[:_to_spreadsheet_ctx] = context
      end

      def with_context(context, &block)
        old = current
        self.current = context
        result = block.call(context)
        self.current = old
        result
      end
    end

    def initialize(wb_options = nil)
      @rules = []
      workbook wb_options if wb_options
    end

    def format_xls(selector = nil, &block)
      process_dsl(selector, &block) if block
      self
    end

    def process_dsl(selector, &block)
      @rule_container = add_rule :container, *selector_query(selector)
      instance_eval(&block)
      @rule_container = nil
    end

    def format(selector = nil, options, &block)
      if !selector && options.is_a?(String)
        selector = options
        options = nil
      else
        options = options.dup
      end

      options ||= block
      selector = selector_query(selector, options)
      add_rule :format, *selector, options
    end

    def add_rule(rule_type, selector_type, selector_value, options = {})
      rule =
        HtmlToXlsx::Rule.make(
         rule_type,
         selector_type,
         selector_value,
         options
        )

      if @rule_container
        @rule_container.children << rule
      else
        @rules << rule
      end

      rule
    end

    def merge(other_context)
      context = Context.new()
      context.rules = rules + other_context.rules
      context
    end

    private

    def selector_query(text, opts = {})
      return [:css, text] if text
      [nil, nil]
    end
  end
end
