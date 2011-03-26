pdf.move_down(20)
pdf.text(h(@check_list.title), :align => :center, :size => 14)
pdf.move_down(20)

items = @check_list.items.map do |item|
  [h(item.title), h(item.place), item.quantity.to_s, l!(item.expiry), ""]
end
items << ["","", "", "", ""] if items.length == 0

pdf.table items, :border_style => :grid,
                      :row_colors => ["FFFFFF","DDDDDD"],
                      :headers => [Prawn::Table::Cell.new(:text => "Titre", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text =>"Emplacement", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text =>"Quantité", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text =>"Expire le", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text => "Contrôle", :font_style => :bold)],
                      :column_widths => { 0 => 160, 1 => 160, 2 => 60, 3 => 80, 4 => 60 },
                      :align => { 0 => :left, 1 => :left, 2 => :center, 3 => :center, 4 => :center }