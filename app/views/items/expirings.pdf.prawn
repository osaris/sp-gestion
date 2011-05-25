pdf.move_down(20)
pdf.text("Liste du matériel expirant dans les 30 prochains jour", :align => :center, :size => 14)
pdf.move_down(20)

header = [["<b>Titre</b>", "<b>Liste</b>", "<b>Emplacement</b>", "<b>Expire le</b>", "<b>Quantité</b>", "<b>Contrôle</b>"]]

items = @items.map do |item|
  [item.title, item.check_list.title, item.place, l(item.expiry, :format => :default), item.quantity.to_s, ""]
end
items << ["","","","","",""] if items.length == 0

pdf.table(header+items, :header => true,
                        :row_colors => ["DDDDDD", "FFFFFF"],
                        :column_widths => [100, 110, 110, 80, 60, 60],
                        :cell_style => { :inline_format => true }) do
  # align 3 last columns center
  columns(3..5).align = :center
  # but force right align of quantity
  rows(1..items.count).column(4).style(:padding_right => 10, :align => :right)
end