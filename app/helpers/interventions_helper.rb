module InterventionsHelper
  
  def options_for_kind
    Intervention::KIND.map { |kind, i| [t("intervention.kind.#{kind}"),i] }.sort {|x,y| x[1] <=> y[1] }
  end
  
  def display_kind(intervention)
    t("intervention.kind."+Intervention::KIND.index(intervention.kind).to_s)
  end
  
  def display_vehicles(intervention)
    intervention.vehicles.collect { |vehicle| vehicle.name }.join(" / ")
  end
  
  def min_date_intervention(station)
    unless station.last_grade_update_at.blank?
      "-#{Date.today-station.last_grade_update_at}d"
    end
  end
  
end