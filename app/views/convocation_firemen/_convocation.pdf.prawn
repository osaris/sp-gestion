fireman = @convocation_fireman.fireman
grade = (@convocation_fireman.grade.nil?||@convocation.hide_grade) ? "" : Grade::GRADE.key(@convocation_fireman.grade)
uniform = @convocation.uniform

if @station.logo?
  pdf.image(open(@station.logo.url), :at => [425, 370], :width => 100, :height => 50)
end
pdf.text(@station.name)
pdf.move_down(40)
pdf.text("CONVOCATION", :align => :center, :size => 14)
pdf.move_down(20)
pdf.text(grade + " " + fireman.firstname + " " + fireman.lastname, :align => :center , :size => 12)
pdf.move_down(20)
pdf.text("Motif : " + @convocation.title)
pdf.move_down(20)
pdf.text("Tenue : #{uniform.title} - #{uniform.description}")
pdf.move_down(20)
pdf.text("Lieu : " + @convocation.place)
pdf.move_down(20)
pdf.text("Date et heure : " + I18n.l(@convocation.date, :format => :default))
unless @convocation.rem.blank?
  pdf.move_down(20)
  pdf.text("Remarque : " + @convocation.rem)
end