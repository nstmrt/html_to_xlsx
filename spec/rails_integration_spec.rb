require 'html_to_xlsx/railtie'

describe HtmlToXlsx::Railtie do
  it 'registers a renderer' do
    expect(HtmlToXlsx.renderer).to eq(:html2xlsx)
    expect(ActionController::Renderers::RENDERERS)
      .to include(HtmlToXlsx.renderer)
  end
end
