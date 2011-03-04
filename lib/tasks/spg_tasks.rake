namespace :spg do
  desc "Run migrations and test in test env"
  task :qa do
    exit_code = 0
    begin
      Rails.env = 'test'
      Rake::Task["db:migrate"].invoke
      Rake::Task["test"].invoke
    rescue Exception => e
      exit_code = 1
    end
    Kernel.exit(exit_code)
  end
end