require 'active_support/core_ext/string'
module HtmlToXlsx
  module Rule
    def self.make(rule_type, selector_type, selector_value, options)
      klass = "HtmlToXlsx::Rule::#{rule_type.to_s.camelize}".constantize
      klass.new(selector_type, selector_value, options)
    end
  end
end
