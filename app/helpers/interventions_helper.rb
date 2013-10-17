# -*- encoding : utf-8 -*-
module InterventionsHelper

  def options_for_kind
    Intervention::KIND.map { |kind, i| [t("intervention.kind.#{kind}"),i] }.sort {|x,y| x[1] <=> y[1] }
  end

  def display_kind_and_subkind(intervention)
    [t("intervention.kind."+Intervention::KIND.key(intervention.kind).to_s),
     intervention.subkind].delete_if { |x| x.to_s.empty? }.join(" / ")
  end

  def display_vehicles(intervention)
    intervention.vehicles.collect { |vehicle| vehicle.name }.join(" / ")
  end

  def min_date_intervention(station)
    if station.last_grade_update_at?
      "-#{Date.today-station.last_grade_update_at}d"
    end
  end

  def intervention_roles_collection(station)
    [['']] + station.intervention_roles.map { |ir| [ir.short_name, ir.id] }
  end

  def display_intervention_role(fireman_intervention)
    fireman_intervention.intervention_role.nil? ? '' : fireman_intervention.intervention_role_short_name
  end

  def map_for(intervention)
    html = content_tag(:div, '', :id => 'google_map', :style => 'width: 450px; height: 250px;')
    html += javascript_include_tag("https://maps.google.com/maps/api/js?&sensor=false&key=#{Rails.configuration.google_api_key}")
    html += javascript_tag("
      var latlng = new google.maps.LatLng(#{intervention.latitude}, #{intervention.longitude});
      var options = {
        center: latlng,
        zoom: 14,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      var map = new google.maps.Map(document.getElementById('google_map'), options);
      var marker = new google.maps.Marker({
        position: new google.maps.LatLng(#{intervention.latitude}, #{intervention.longitude}),
        map: map
      });
    ")
  end

  def map_for_stats(data)
    view = ActionView::Base.new(Rails.root.join('app', 'views'))
    view.class_eval do
      include InterventionsHelper
    end
    html = content_tag(:div, '', :id => 'google_map', :style => 'width: 100%; height: 480px')
    html += javascript_include_tag("https://maps.google.com/maps/api/js?&sensor=false&key=#{Rails.configuration.google_api_key}")
    js = "
      var bounds = new google.maps.LatLngBounds();
      var infoWindow = new google.maps.InfoWindow({});
      var options = {
        zoom: 14,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      var map = new google.maps.Map(document.getElementById('google_map'), options);
    "
    data.each do |intervention|
      js += "
        var latlng = new google.maps.LatLng(#{intervention.latitude}, #{intervention.longitude});
        var marker = new google.maps.Marker({
          position: latlng,
          map: map
        });
        bounds.extend(latlng);
        google.maps.event.addListener(marker, 'click', function() {
          infoWindow.setContent('#{escape_javascript(view.render(:partial => "interventions/stats/intervention_map",
                                                                 :locals => { :intervention => intervention}).to_s)}');
          infoWindow.open(map, this);
        });
      "
    end
    js += "
      map.fitBounds(bounds);
      map.panToBounds(bounds);
    "
    html += javascript_tag(js)
  end

end
