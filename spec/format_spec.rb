require 'spec_helper'

describe HtmlToXlsx::Rule::Format do
  let :spreadsheet do
    build_spreadsheet file: 'table.html.haml'
  end

  let(:sheet) { spreadsheet.workbook.worksheets[0] }

  context 'local styles' do
    it 'runs lambdas on properties' do
      cell = sheet.rows[1].cells[0]
      styles = sheet.workbook.styles
      font_id = styles.cellXfs[cell.style].fontId
      expect(styles.fonts[font_id].color.rgb)
        .to eq(Axlsx::Color.new(rgb: 'cccccc').rgb)
    end

    it 'runs blocks for selectors' do
      expect(sheet.name).to eq('Test')
    end
  end
end
