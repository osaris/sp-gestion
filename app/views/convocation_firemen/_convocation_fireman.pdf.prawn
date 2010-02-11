fireman = convocation_fireman.fireman
grade = convocation_fireman.grade.nil? ? "" : Grade::GRADE.index(convocation_fireman.grade)

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