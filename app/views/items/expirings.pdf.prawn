pdf.move_down(20)
pdf.text("Liste du matériel expirant dans les 30 prochains jour", :align => :center, :size => 14)
pdf.move_down(20)

items = @items.map do |item|
  [h(item.title), h(item.check_list.title), l(item.expiry, :format => :default), item.quantity.to_s, ""]
end
items << ["","","","",""] if items.length == 0

pdf.table items, :border_style => :grid,
                      :row_colors => ["FFFFFF","DDDDDD"],
                      :headers => [Prawn::Table::Cell.new(:text => "Titre", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text => "Liste", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text =>"Expire le", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text =>"Quantité", :font_style => :bold),
                                   Prawn::Table::Cell.new(:text => "Contrôle", :font_style => :bold)],
                      :column_widths => { 0 => 150, 1 => 150, 2 => 80, 3 => 70, 4 => 70 },
                      :align => { 0 => :left, 1 => :left, 2 => :center, 3 => :center, 4 => :center }