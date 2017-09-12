require 'rails/railtie'
module HtmlToXlsx
  class Railtie < ::Rails::Railtie
    config.html_to_xlsx = ActiveSupport::OrderedOptions.new
    config.html_to_xlsx.renderer = HtmlToXlsx.renderer

    config.after_initialize do |app|
      HtmlToXlsx.instance_variable_set(
        '@renderer',
        app.config.html_to_xlsx.renderer
      )

      require 'html_to_xlsx/rails/action_pack_renderers'
      require 'html_to_xlsx/rails/view_helpers'
      require 'html_to_xlsx/rails/mime_types'

      ActionView::Base.send(:include, HtmlToXlsx::Rails::ViewHelpers)
    end
  end
end
