# -*- encoding : utf-8 -*-
# The core of the job
class Intervention < ActiveRecord::Base

  belongs_to :station
  has_many :intervention_vehicles, :dependent => :destroy
  has_many :vehicles, :through => :intervention_vehicles
  has_many :fireman_interventions, :dependent => :destroy, :order => 'fireman_interventions.grade DESC'
  has_many :firemen, :through => :fireman_interventions

  validates_presence_of :city, :message => "La ville est obligatoire."
  validates_presence_of :place, :message => "Le lieu est obligatoire."
  validates_presence_of :kind
  # FIXME record is saved even if this validation failed, it's a Rails bug
  # https://rails.lighthouseapp.com/projects/8994/tickets/922-has_many-through-transaction-rollback
  validates_presence_of :firemen, :message => "Le personnel est obligatoire."
  validates_datetime :start_date, :invalid_datetime_message => "La date de début n'est pas valide."
  validates_datetime :end_date, :on_or_before => :now, :after => :start_date, :invalid_datetime_message => "La date de fin n'est pas valide."
  validates_numericality_of :number, :message => "Le numéro est obligatoire."
  validates_uniqueness_of :number, :scope => :station_id, :message => "Le numéro doit être unique."

  acts_as_geocodable :address => {:street => :place, :locality => :city}

  KIND = {
    :sap => 1,
    :inc => 2,
    :div => 3,
    :sr => 4
  }.freeze

  scope :newer, order('start_date DESC')
  scope :latest, newer.limit(1)

  def initialize(params = nil)
    super
    self.kind ||= KIND[:sap]
    self.number ||= init_number
  end

  def self.stats_by_type(station, year)
    Intervention.where(["station_id = ? AND YEAR(start_date) = ?", station.id, year]).group(:kind).count
  end

  def self.stats_by_subtype(station, year)
    Intervention.where(["station_id = ? AND YEAR(start_date) = ?", station.id, year]).group(:subtype).count
  end

  def self.stats_by_month(station, year)
    result = Intervention.where(["station_id = ? AND YEAR(start_date) = ?", station.id, year]).group('MONTH(start_date)').count
    result = Hash[1,0,2,0,3,0,4,0,5,0,6,0,7,0,8,0,9,0,10,0,11,0,12,0].merge(result)
    result.sort { |result_a, result_b| result_a[0].to_i <=> result_b[0].to_i }.map{ |month, number| number }
  end

  def self.stats_by_vehicle(station, year)
		Intervention.select("vehicles.name, COUNT(interventions.id) AS count") \
                .joins(:vehicles) \
    						.where(["interventions.station_id = ? AND YEAR(interventions.start_date) = ?", station.id, year]) \
                .group("vehicles.name")
                .collect { |i| [i[:name], i[:count].to_i] }
  end

  def self.min_max_year(station)
    result = Intervention.select("MIN(YEAR(start_date)) AS min_year, MAX(YEAR(end_date)) AS max_year") \
                         .where(:station_id => station.id) \
                         .first
    [result[:min_year], result[:max_year]]
  end

  def editable?
    (self.station.last_grade_update_at.blank?) or (self.start_date > self.station.last_grade_update_at)
  end

  def self.cities(station)
    result = Intervention.select("DISTINCT(city) AS city") \
                         .where(["interventions.city IS NOT NULL AND interventions.station_id = ?", station.id]) \
                         .order('city')
    result.collect { |intervention| intervention.city }
  end

  def self.subtypes(station)
  	result = Intervention.select("DISTINCT(subtype) AS subtype") \
    										 .where(["interventions.subtype IS NOT NULL AND interventions.station_id = ?", station.id]) \
                         .order('subtype')

    result.collect { |intervention| intervention.subtype }
  end
  
  private

  def init_number
    # casting because number is stored as a varchar (for custom format)
    result = Intervention.select("COALESCE(MAX(CAST(number AS SIGNED)),0) AS max_number") \
                         .where(:station_id => self.station.id) \
                         .first
    result[:max_number].to_i + 1
  end

end
