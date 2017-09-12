require 'active_support'
require 'action_controller/metal/renderers'

if ActiveSupport.respond_to?(:version) &&
   ActiveSupport.version.to_s >= '4.2.0'
  require 'action_controller/responder'
else
  require 'action_controller/metal/responder'
end

ActionController::Renderers.add HtmlToXlsx.renderer do |template, options|
  filename = options[:filename] ||
             options[:template] ||
             'data'
  c = ToSpreadsheet::Context.global.merge(ToSpreadsheet::Context.new)
  data = HtmlToXlsx::Context.with_context(c) do |context|
    html = render_to_string(
      template,
      options.merge(template: template.to_s, formats: ['xlsx', 'html'])
    )

    HtmlToXlsx::Renderer.to_data(html, context)
  end

  send_data(
    data,
    type: HtmlToXlsx.renderer,
    disposition: %(attachment; filename="#{filename}.xlsx")
  )
end

class ActionController::Responder
  define_method "to_#{HtmlToXlsx.renderer}" do
    controller.render(HtmlToXlsx.renderer => controller.action_name)
  end
end
