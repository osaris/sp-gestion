if @station.logo?
  pdf.image(open(@station.logo.url), :at => [425, 370], :width => 100, :height => 50)
end

pdf.text(@station.name, :size => 12)
pdf.move_down(20)
pdf.text('<b>' + grade_and_name(@fireman) + '</b>', :size => 14, :inline_format => true)
if @fireman.regimental_number?
  pdf.move_down(20)
  pdf.text('<b>N° de matricule</b> : ' + @fireman.regimental_number, :inline_format => true)
end
if @fireman.cached_tag_list?
  pdf.move_down(20)
  pdf.text('<b>Etiquette(s)</b> : ' + @fireman.cached_tag_list, :inline_format => true)
end
if @fireman.rem?
  pdf.move_down(20)
  pdf.text('<b>Remarque</b> : ' + @fireman.rem, :inline_format => true)
end

pdf.move_down(40)
pdf.text('<b>Formations</b>', :size => 12, :inline_format => true)

if can? :read, FiremanTraining
  header = [["<b>Nom</b>", "<b>Date</b>", "<b>Remarque</b>"]]

  trainings = @trainings.each do |fireman_training|
    [fireman_training.training.short_name,
     I18n.l(fireman_training.achieved_at, :format => :default),
     fireman_training.rem]
  end

  pdf.table(header+trainings, :header => true,
                    :row_colors => ["DDDDDD", "FFFFFF"],
                    :column_widths => [150, 70, 310],
                    :cell_style => { :inline_format => true },
                    :width => 530)
end
