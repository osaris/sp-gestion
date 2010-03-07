pdf.move_down(20)
pdf.text("Liste d'appel - " + h(@convocation.title), :align => :center, :size => 14)
pdf.text(I18n.l(@convocation.date, :format => :default), :align => :center, :size => 12)
pdf.move_down(20)

@convocation_firemen.group_by(&:status).each do |group, convocation_firemen|
  pdf.move_down(20)
  pdf.text(Fireman::STATUS.index(group), :align => :center, :size => 12)
  pdf.move_down(20)
  
  firemen = convocation_firemen.map do |convocation_fireman|
    [Grade::GRADE.index(convocation_fireman.grade), 
     h(convocation_fireman.fireman.lastname), 
     h(convocation_fireman.fireman.firstname), ""]
  end
  
  pdf.table firemen, :border_style => :grid,
                     :row_colors => ["FFFFFF","DDDDDD"],
                     :headers => [Prawn::Table::Cell.new(:text => "Grade", :font_style => :bold),
                                  Prawn::Table::Cell.new(:text => "Nom", :font_style => :bold),
                                  Prawn::Table::Cell.new(:text => "Prénom", :font_style => :bold),
                                  Prawn::Table::Cell.new(:text => "Présent ?", :font_style => :bold)],
                     :column_widths => { 0 => 140, 1 => 140, 2 => 140 , 3 => 80 },
                     :align => { 0 => :left, 1 => :left, 2 => :left, 3 => :center}
end