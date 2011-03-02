# -*- encoding : utf-8 -*-
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require File.expand_path(File.dirname(__FILE__) + '/blueprints')
require 'rails/test_help'
require 'authlogic/test_case'
require File.expand_path(File.dirname(__FILE__) + '/shoulda_matchers/custom_matchers')

class ActiveSupport::TestCase
  include RR::Adapters::TestUnit

  include Shoulda::Matchers::Custom
  extend Shoulda::Matchers::Custom

  # FIXME this should be integrated in machinist gem but isn't ready in version 2.0.0.beta2
  def plan(object)
    assigned_attributes = {}
    object.attributes.each do |key, value|
      assigned_attributes[key.to_sym] = value
    end
  end

  def login(station = Station.make!, user = User.make!(:confirmed))
    @station = station
    @user = user
    @user.station = @station

    @request.host = "#{@station.url}.sp-gestion.fr"

    UserSession.create(@user)
  end

  def logout(user)
    session = UserSession.find(user)
    session.destroy
  end

  def send_file_to_disk(content, filename)
    test_file_path = "#{Rails.root}/tmp/tests/"
    FileUtils.mkdir_p(test_file_path)
    File.open(test_file_path+filename, "w") do |f|
      f.write(content.force_encoding('UTF-8'))
    end
  end

  # data

  def make_station_with_user(attributes = {})
    s = Station.make(attributes)
    s.users << User.new
    s.save
    s
  end

  def make_fireman_with_grades(attributes = {})
    f = Fireman.make(attributes)
    f.grades = Grade::new_defaults
    f.grades.last.date = 2.months.ago
    f.save
    f
  end

  def make_convocation_with_firemen(attributes = {}, number_of_firemen = 1)
    c = Convocation.make(attributes)
    number_of_firemen.times do
      c.firemen << make_fireman_with_grades(:station => c.station)
    end
    c.save
    c
  end

  def make_check_list_with_items(attributes = {})
    cl = CheckList.make!(attributes)
    5.times { cl.items << Item.make! }
    cl.save
    cl
  end

  def make_intervention_with_firemen(attributes = {})
    i = Intervention.make(attributes)
    i.firemen << make_fireman_with_grades(:station => i.station)
    i.save
    i
  end
end

# Disable transparent delayed_job methods in test mode
module Delayed
  class DelayProxy < ActiveSupport::BasicObject
    def method_missing(method, *args)
      # puts "Debug : " + @payload_class.name + ".new(" + @target.name + "," + method.to_s + "," + args.to_s+").perform"
      @payload_class.new(@target, method.to_sym, args).perform
    end
  end
end
