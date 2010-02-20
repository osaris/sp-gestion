namespace :spg do
  desc "Run test and metric_fu if tests are ok"
  task :qa do
    exit_code = 0
    begin
      RAILS_ENV = 'test'
      Rake::Task["db:migrate"].invoke
      Rake::Task["test"].invoke
      Rake::Task["metrics:all"].invoke
    rescue Exception => e
      exit_code = 1
    end
    Kernel.exit(exit_code)
  end
end