pdf.move_down(20)
pdf.text("Liste d'appel - " + h(@convocation.title), :align => :center, :size => 14)
pdf.text(I18n.l(@convocation.date, :format => :default), :align => :center, :size => 12)
pdf.move_down(20)

header = [["<b>Grade</b>", "<b>Nom</b>", "<b>Prénom</b>", "<b>Présent ?</b>"]]

@convocation_firemen.group_by(&:status).each do |group, convocation_firemen|
  pdf.move_down(20)
  pdf.text(Fireman::STATUS.key(group), :align => :center, :size => 12)
  pdf.move_down(20)

  firemen = convocation_firemen.map do |convocation_fireman|
    [Grade::GRADE.key(convocation_fireman.grade),
     h(convocation_fireman.fireman.lastname),
     h(convocation_fireman.fireman.firstname), ""]
  end

  pdf.table(header+firemen, :header => true,
                            :row_colors => ["DDDDDD", "FFFFFF"],
                            :column_widths => [150, 150, 140, 80],
                            :cell_style => { :inline_format => true }) do
    # align last column center
    columns(3).align = :center
  end
end