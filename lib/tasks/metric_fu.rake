begin  
  require 'metric_fu'  
  
  MetricFu::Configuration.run do |config|  
    config.metrics = [:flog, :flay, :rcov]  
    config.graphs  = []
    
    config.flog = { :dirs_to_flog => ['app'] }  
    config.flay = { :dirs_to_flay => ['app', 'lib'],
                    :minimum_score => 100  }
    config.rcov = { :environment => 'test',
                    :test_files => ['test/unit/*_test.rb', 'test/unit/helpers/*_test.rb', 'test/functional/*_test.rb'],
                    :rcov_opts => ["-Itest",
                                   "--sort coverage", 
                                   "--no-html", 
                                   "--text-coverage",
                                   "--no-color",
                                   "--profile",
                                   "--rails",
                                   "--exclude \" rubygems/*, gems/*, rcov*\""]}
  end
  
rescue LoadError  
end