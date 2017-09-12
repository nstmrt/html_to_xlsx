require 'spec_helper'

describe HtmlToXlsx::Renderer do
  let :spreadsheet do
    build_spreadsheet file: 'two_tables.html.haml'
  end

  context 'worksheets' do
    it 'are created 1 per <table>' do
      expect(spreadsheet.workbook.worksheets.length).to eq(2)
    end
  end
end
