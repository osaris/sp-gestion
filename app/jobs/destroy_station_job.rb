class DestroyStationJob < ActiveJob::Base
  queue_as :default

  def perform(station)
    station.destroy
  end
end
