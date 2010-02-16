begin  
  require 'metric_fu'  
  
  MetricFu::Configuration.run do |config|  
    config.metrics = [:stats, :rcov]  
    config.graphs  = []
    
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