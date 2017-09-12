html_to_xlsx lets your Rails 3+ app render Excel files using the existing slim/haml/erb/etc views.

Installation
------------

Add it to your Gemfile:
```ruby
gem 'html_to_xlsx', git: 'https://github.com/nstmrt/html_to_xlsx'
```

Usage
-----

In the controller:
```ruby
# my_thingies_controller.rb
class MyThingiesController < ApplicationController
  respond_to :xlsx, :html
  def index
    @my_items = MyItem.all
    respond_to do |format|
      format.html
      format.xlsx { render xlsx: :index, filename: 'my_items_doc' }
    end
  end
end
```

In the view partial:
```haml
# _my_items.haml
%table
  %caption My items
  %thead
    %tr
      %td ID
      %td Name
  %tbody
    - my_items.each do |my_item|
      %tr
        %td.number= my_item.id
        %td= my_item.name
  %tfoot
    %tr
      %td(colspan="2") #{my_items.length}
```

In the XLSX view:
```haml
# index.xlsx.haml
= render 'my_items', my_items: @my_items
```

In the HTML view:
```haml
# index.html.haml
= link_to 'Download spreadsheet', my_items_url(format: :xlsx)
= render 'my_items', my_items: @my_items
```

### Worksheets

Every table in the view will be converted to a separate sheet.
The sheet title will be assigned to the value of the table’s caption element if it exists.

### Formatting

You can define formats in your view file (local to the view) or in the initializer

```ruby
format_xls 'table.my-table' do
  format 'th', b: true # bold
  format 'tbody tr', bg_color: lambda { |row| 'ddffdd' if row.index.odd? }
  format 'td.custom', lambda { |cell| modify cell somehow.}
end
```

### HTML nodes

html_to_xlsx associates HTML nodes with Axlsx objects as follows:

| HTML tag | Axlsx object |
|----------|--------------|
| table    | worksheet    |
| tr       | row          |
| td, th   | cell         |


### Using along side axlsx-rails
If you are using [axlsx-rails](https://github.com/straydogstudio/axlsx_rails), :xlsx renderer might have already been defined. In that case define a custome renderer using
```ruby
# app/config/application.rb
config.html_to_xlsx.renderer = :html2xlsx
```

And then in controller
```ruby
respond_to do |format|
  format.html2xlsx
end
```
