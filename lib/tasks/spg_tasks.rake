namespace :test do
  desc 'Measures test coverage'
  task :coverage do
    rm_f("doc/coverage/coverage.data")
    rcov = "rcov -Itest --rails --aggregate doc/coverage/coverage.data -T -x \" rubygems/*,/Library/Ruby/Site/*,gems/*,rcov*\" --output doc/coverage/"
    system("#{rcov} --no-html test/unit/*_test.rb test/unit/helpers/*_test.rb test/functional/*_test.rb")
    system("#{rcov} --html test/integration/*_test.rb")
    system("open doc/coverage/index.html") if PLATFORM['darwin']
  end
end