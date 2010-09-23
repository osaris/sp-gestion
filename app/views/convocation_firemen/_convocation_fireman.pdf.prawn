fireman = convocation_fireman.fireman
grade = (convocation_fireman.grade.nil?||convocation.hide_grade) ? "" : Grade::GRADE.index(convocation_fireman.grade)

if @station.logo?
  _pdf.image(@station.logo, :at => [425, 370], :width => 100, :height => 50)
end
_pdf.text(h(@station.name))
_pdf.move_down(40)
_pdf.text("CONVOCATION", :align => :center, :size => 14)
_pdf.move_down(20)
_pdf.text(grade + " " + h(fireman.firstname) + " " + h(fireman.lastname), :align => :center , :size => 12)
_pdf.move_down(20)
_pdf.text("Motif : " + h(convocation.title))
_pdf.move_down(20)
_pdf.text("Lieu : " + h(convocation.place))
_pdf.move_down(20)
_pdf.text("Date et heure : " + I18n.l(convocation.date, :format => :default))
unless convocation.rem.blank?
  _pdf.move_down(20)
  _pdf.text("Remarque : " + h(convocation.rem))
end