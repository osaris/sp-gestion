# -*- encoding : utf-8 -*-
class FiremanTraining < ActiveRecord::Base

  belongs_to :fireman
  belongs_to :training
  belongs_to :station

  delegate :short_name, :to => :training, :prefix => true

  validates_uniqueness_of :training_id, :scope => [:fireman_id], :message => "La formation existe déjà pour cette personne."
  validates_presence_of :training_id
  validates_presence_of :achieved_at, :message => "La date est obligatoire."
  validates_date :achieved_at

  before_create :set_station_id

  def self.all_to_hash(station_id)
  Hash[*FiremanTraining.where(:station_id => station_id).collect { |v|
      [v.fireman_id.to_s+'_'+v.training_id.to_s, v.achieved_at]
    }.flatten]
  end

  protected

  def set_station_id
    self.station_id = self.training.station_id
  end

end