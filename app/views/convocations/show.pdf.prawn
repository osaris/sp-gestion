@convocation.convocation_firemen.each do |convocation_fireman|
  fireman = convocation_fireman.fireman
  grade = convocation_fireman.grade.nil? ? "" : Grade::GRADE.index(convocation_fireman.grade)
  
  pdf.text(h(@station.name))
  pdf.move_down(40)
  pdf.text("CONVOCATION", :align => :center, :size => 14)
  pdf.move_down(20)
  pdf.text(grade + " " + h(fireman.firstname) + " " + h(fireman.lastname), :align => :center , :size => 12)
  pdf.move_down(20)
  pdf.text("Motif : " + h(@convocation.title))
  pdf.move_down(20)
  pdf.text("Lieu : " + h(@convocation.place))
  pdf.move_down(20)
  pdf.text("Date et heure : " + I18n.l(@convocation.date, :format => :default))
  pdf.start_new_page unless (pdf.page_count == @convocation.firemen.length)
end