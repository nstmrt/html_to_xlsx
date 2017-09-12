ENV['RAKE_ENV'] ||= 'test'
$: << File.expand_path('../lib', __FILE__)
require 'combustion'
require 'html_to_xlsx'

Combustion.initialize! :action_view, :action_controller do
  config.html_to_xlsx.renderer = :html2xlsx
end

require 'haml'

module TestRendering
  def build_spreadsheet(src = {})
    haml = if src[:haml]
             src[:haml]
           elsif src[:file]
             File.read(File.expand_path "support/#{src[:file]}", File.dirname(__FILE__))
           end

    c = HtmlToXlsx::Context.global.merge(HtmlToXlsx::Context.new)
    HtmlToXlsx::Context.with_context(c) do |context|
      html = Haml::Engine.new(haml).render(self)
      HtmlToXlsx::Renderer.to_package(html, context)
    end
  end
end


require 'html_to_xlsx/rails/view_helpers'

RSpec.configure do |config|
  include TestRendering
  include ::HtmlToXlsx::Rails::ViewHelpers
end
