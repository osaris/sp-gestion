class FiremenChartsService

  def initialize(data)
    @data = data
  end

  def interventions_by_role
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Interventions par rôle (Total : #{@data[:sum]})",
              :style             => {
                :fontSize => '12px'
              })
      f.tooltip(:pointFormat => '{point.percentage:.1f} %')
      f.series(:data => @data[:data].to_a,
               :name => 'Interventions')
      f.chart({:type    => "pie",
               :height  => 350})
    end
  end

  def interventions_by_hour
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Interventions par heure (Total : #{@data[:sum]})",
              :style             => {
                :fontSize => '12px'
              })
      f.tooltip({:headerFormat => '<b>{point.x}h</b> <br />',
                 :pointFormat  => '{point.y} interventions'})
      f.series(:data => @data[:data].to_a,
               :name => 'Interventions')
      f.xAxis(:categories => (0..23).to_a)
      f.yAxis({:minTickInterval => 1,
               :title           => ''})
      f.chart({:type    => "column",
               :height  => 350})
    end
  end

end
