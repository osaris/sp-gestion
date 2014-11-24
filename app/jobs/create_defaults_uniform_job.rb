class CreateDefaultsUniformJob < ActiveJob::Base
  queue_as :default

  def perform(station)
    Uniform.delay.create_defaults(station)
  end
end
