namespace :spg do
  desc "Run test and metric_fu if tests are ok"
  task :qa => :environment do
    result_test = run_and_check_for_exception("test")
    result_metrics = run_and_check_for_exception("metrics:all") if result_test
    Kernel.exit(result_test.to_i)
  end
end

def run_and_check_for_exception(task_name)  
  puts "*** Running #{task_name} features ***"  
  begin  
    Rake::Task[task_name].invoke  
  rescue Exception => e  
    return false  
  end  
  true  
end