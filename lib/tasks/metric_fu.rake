begin  
  require 'metric_fu'  
  
  MetricFu::Configuration.run do |config|  
    config.metrics = [:flog, :flay]  
    config.graphs  = [:flog, :flay]
    
    config.flog = { :dirs_to_flog => ['app'] }  
    config.flay = { :dirs_to_flay => ['app', 'lib'],
                    :minimum_score => 100  }
  end
  
rescue LoadError  
end