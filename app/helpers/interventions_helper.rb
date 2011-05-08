# -*- encoding : utf-8 -*-
module InterventionsHelper
  
  def options_for_kind
    Intervention::KIND.map { |kind, i| [t("intervention.kind.#{kind}"),i] }.sort {|x,y| x[1] <=> y[1] }
  end
  
  def display_kind_and_subtype(intervention)
    [t("intervention.kind."+Intervention::KIND.key(intervention.kind).to_s),
     intervention.subtype].delete_if { |x| x.to_s.empty? }.join(" / ")
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
