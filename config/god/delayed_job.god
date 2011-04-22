RAILS_ENV = "production"
RAILS_ROOT = "/home/raphael/public_html/sp-gestion.fr/current"
PID_FILE = "/home/raphael/public_html/sp-gestion.fr/shared/pids/delayed_job.pid"

God.watch do |w|
  w.name = "delayed_job_worker"
  w.interval = 10.seconds

  w.start = "RAILS_ENV=#{RAILS_ENV} #{RAILS_ROOT}/script/delayed_job start"
  w.stop = "#{RAILS_ROOT}/script/delayed_job stop"
  w.restart = "#{RAILS_ROOT}/script/delayed_job restart"
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = PID_FILE

  w.uid = "raphael"
  w.gid = "raphael"
  w.behavior(:clean_pid_file)

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_exits)
  end

end