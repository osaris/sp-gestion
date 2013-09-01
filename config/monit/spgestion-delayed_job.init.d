! /bin/sh

### BEGIN INIT INFO
# Provides:          spgestion-delayed_job
# Required-Start:
# Required-Stop:
# Should-Start:
# Should-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: SPGestion delayed_job
# Description:       SP-Gestion background jobs (delayed_job) service engine
### END INIT INFO
set -e
APP_PATH="/home/raphael/sites/sp-gestion.fr/current/"

case "$1" in
  start)
        echo -n "Starting delayed_job: "
        cd $APP_PATH && sudo -u raphael RAILS_ENV=production ./script/delayed_job start && cd -
        echo "done."
        ;;
  stop)
        echo -n "Stopping delayed_job: "
        cd $APP_PATH && sudo -u raphael RAILS_ENV=production ./script/delayed_job stop && cd -
        echo "done."
        ;;
  restart)
        echo -n "Restarting delayed_job: "
        cd $APP_PATH && sudo -u raphael RAILS_ENV=production ./script/delayed_job restart && cd -
        echo "done."
        ;;
  *)
    N=/etc/init.d/spgestion-delayed_job
    echo "Usage: $N {start|stop|restart}" >&2
    exit 1
    ;;
esac

exit 0