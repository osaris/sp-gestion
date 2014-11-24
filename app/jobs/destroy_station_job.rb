class DestroyStationJob < ActiveJob::Base
  queue_as :default

  def perform(station)
    logger.info(station.inspect)
    station.destroy
  end
end
