pdf.move_down(20)
pdf.text(h(@check_list.title), :align => :center, :size => 14)
pdf.move_down(20)

header = [["<b>Titre</b>", "<b>Emplacement</b>", "<b>Quantité</b>", "<b>Expire le</b>", "<b>Contrôle</b>"]]

items = @check_list.items.map do |item|
  [h(item.title), h(item.place), item.quantity.to_s, l!(item.expiry), ""]
end
items << ["","", "", "", ""] if items.length == 0

pdf.table header+items, :header => true,
                        :row_colors => ["DDDDDD", "FFFFFF"],
                        :column_widths => [160, 160, 60, 80, 60],
                        :cell_style => { :inline_format => true } do
  # align 3 last columns center
  columns(2..4).align = :center
  # but force right align of quantity
  rows(1..items.count).column(2).style(:padding_right => 10, :align => :right)
end