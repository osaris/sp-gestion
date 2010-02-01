pdf.move_down(20)
pdf.text("Liste du matériel expirant dans les 30 prochains jour", :align => :center, :size => 14)
pdf.move_down(20)

items = @items.map do |item|
  [h(item.title), h(item.check_list.title), h(item.place), l(item.expiry, :format => :default), item.quantity.to_s, ""]
end
items << ["","","","","",""] if items.length == 0

pdf.table items, :border_style => :grid,
                      :row_colors => ["FFFFFF","DDDDDD"],
                      :headers => [Prawn::Table::Cell.new(:text => "Titre", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text => "Liste", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text => "Emplacement", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text =>"Expire le", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text =>"Quantité", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text => "Contrôle", :font_style => :bold)],
                      :column_widths => { 0 => 110, 1 => 110, 2 => 110 , 3 => 80, 4 => 60, 5 => 60 },
                      :align => { 0 => :left, 1 => :left, 2 => :left, 3 => :center, 4 => :center, 5 => :center }