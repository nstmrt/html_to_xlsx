require 'action_dispatch/http/mime_type'
unless Mime::Type.lookup_by_extension(HtmlToXlsx.renderer)
  Mime::Type.register(
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    HtmlToXlsx.renderer
  )
end
