require 'html_to_xlsx/version'
require 'html_to_xlsx/context'
require 'html_to_xlsx/renderer'

module HtmlToXlsx
  class << self
    def renderer
      @renderer ||= :xlsx
    end
  end
end

require 'html_to_xlsx/railtie' if defined?(Rails)
