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
end
