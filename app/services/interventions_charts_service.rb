class InterventionsChartsService

  include FiremenHelper

  def initialize(data, sum)
    @data = data
    @sum = sum
  end

  def by_city
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Interventions par ville (Total : #{@sum})",
              :style             => {
                :fontSize => '12px'
            })
      f.tooltip(:pointFormat => '{point.percentage:.1f} %')
      f.series(:data => @data.to_a,
               :name => 'Interventions')
      f.chart({:type    => "pie",
               :height  => 350})
    end
  end

  def by_firemen
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Interventions par personnel (Total : #{@sum})",
              :style             => {
                :fontSize => '12px'
            })
      f.tooltip(:pointFormat => '{point.percentage:.1f} %')
      f.series(:data => @data.to_a
                             .map { |fireman| [grade_and_name(firstname: fireman[0],
                                                              lastname:fireman[1],
                                                              grade: fireman[2]),
                                                              fireman.last] },
               :name => 'Interventions')
      f.chart({:type    => "pie",
               :height  => 350})
    end
  end

  def by_vehicle
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Interventions par véhicule (Total : #{@sum})",
              :style             => {
                :fontSize => '12px'
            })
      f.tooltip(:pointFormat => '{point.percentage:.1f} %')
      f.series(:data => @data.to_a,
               :name => 'Interventions')
      f.chart({:type    => "pie",
               :width   => 570,
               :height  => 350})
    end
  end

  def by_hour
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Interventions par heure (Total : #{@sum})",
              :style             => {
                :fontSize => '12px'
              })
      f.tooltip({:headerFormat => '<b>{point.x}h</b> <br />',
                 :pointFormat  => '{point.y} interventions'})
      f.series(:data => @data,
               :name => 'Interventions')
      f.xAxis(:categories => (0..23).to_a)
      f.chart({:type    => "column",
               :height  => 350})
    end
  end

  def by_month
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Interventions par mois (Total : #{@sum})",
              :style             => {
                :fontSize => '12px'
              })
      f.tooltip({:headerFormat => '<b>{point.x}</b> <br />',
                 :pointFormat  => '{point.y} interventions'})
      f.series(:data => @data,
               :name => 'Interventions')
      f.xAxis(:categories => I18n.t("date.abbr_month_names").compact)
      f.chart({:type    => "column",
               :height  => 350})
    end
  end

  def by_subkind
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Interventions par sous-type (Total : #{@sum})",
              :style             => {
                :fontSize => '12px'
              })
      f.tooltip(:pointFormat => '{point.percentage:.1f} %')
      f.series(:data => @data.to_a,
               :name => 'Interventions')
      f.chart({:type    => "pie",
               :height  => 350})
    end
  end

  def by_type
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Interventions par type (Total : #{@sum})",
              :style             => {
                :fontSize => '12px'
              })
      f.tooltip(:pointFormat => '{point.percentage:.1f} %')
      f.series(:data => Intervention::KIND.to_a.map { |kind, i|
                  [I18n.t("intervention.kind.#{kind}"), @data[i].to_i]
                },
               :name => 'Interventions')
      f.chart({:type    => "pie",
               :height  => 350})
    end
  end
end
