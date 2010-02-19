namespace :spg do
  desc 'Run test and metric_fu if tests are ok'
  task :qa => :environment do
    Rake::Task["test"].reenable
    result_test = Rake::Task["test"].invoke
    if result_test == 0
      Rake::Task["metrics:all"].reenable
      result_metrics = Rake::Task["metrics:all"].invoke
    end
    return (result_test || result_metrics)
  end
end