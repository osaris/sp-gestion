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
  
end