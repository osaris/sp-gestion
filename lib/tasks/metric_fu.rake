begin  
  require 'metric_fu'  
  
  MetricFu::Configuration.run do |config|  
    config.metrics  = [:churn, :saikuro, :stats, :flog, :flay, :reek, :roodi, :rcov]
    config.graphs   = [:flog, :flay, :reek, :roodi, :rcov]
    
    config.flay     = { :dirs_to_flay => ['app', 'lib'],
                        :minimum_score => 100  }
    config.flog     = { :dirs_to_flog => ['app', 'lib']  }
    config.reek     = { :dirs_to_reek => ['app', 'lib']  }
    config.roodi    = { :dirs_to_roodi => ['app', 'lib'] }
    config.saikuro  = { :output_directory => 'scratch_directory/saikuro', 
                        :input_directory => ['app', 'lib'],
                        :cyclo => "",
                        :filter_cyclo => "0",
                        :warn_cyclo => "5",
                        :error_cyclo => "7",
                        :formater => "text"} #this needs to be set to "text"
    config.churn    = { :start_date => "1 year ago", :minimum_churn_count => 10}
    config.rcov     = { :environment => 'test',
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