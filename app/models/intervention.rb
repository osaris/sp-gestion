# -*- encoding : utf-8 -*-
class Intervention < ActiveRecord::Base

  belongs_to :station
  has_many :intervention_vehicles, :dependent => :destroy
  has_many :vehicles, :through => :intervention_vehicles
  has_many :fireman_interventions, -> { order 'fireman_interventions.grade DESC' }, :dependent => :destroy
  has_many :firemen, :through => :fireman_interventions

  accepts_nested_attributes_for :fireman_interventions, :allow_destroy => true

  validates_presence_of :city, :message => "La ville est obligatoire."
  validates_presence_of :place, :message => "Le lieu est obligatoire."
  validates_presence_of :kind
  validates_datetime :start_date, :invalid_datetime_message => "La date de début n'est pas valide."
  validates_datetime :end_date, :on_or_before => :now, :after => :start_date, :invalid_datetime_message => "La date de fin n'est pas valide."
  validates_numericality_of :number, :message => "Le numéro est obligatoire."
  validates_with InterventionValidator

  geocoded_by :full_address
  after_validation :geocode

  KIND = {
    :sap => 1,
    :inc => 2,
    :div => 3,
    :sr => 4
  }.freeze

  scope :newer, -> { order('start_date DESC') }
  scope :latest, -> { newer.limit(1) }
  scope :for_year_and_station, lambda {
    |station, year| where("interventions.station_id = ? AND YEAR(interventions.start_date) = ?", station.id, year)
  }

  def initialize(params = nil, *args)
    super
    self.kind ||= KIND[:sap]
    self.number ||= init_number
  end

  def initialized_fireman_interventions
    [].tap do |o|
      self.station.firemen.not_resigned.active.order_by_grade_and_lastname.each do |fireman|
        if fi = fireman_interventions.find { |fi| fi.fireman_id == fireman.id }
          o << fi.tap { |fi| fi.enable ||= true }
        else
          o << FiremanIntervention.new(:fireman => fireman)
        end
      end
    end
  end

  def self.stats_by_type(station, year)
    Intervention.for_year_and_station(station, year).group(:kind).count
  end

  def self.stats_by_subkind(station, year)
    Intervention.select("COUNT(*) AS count, COALESCE(subkind, '') AS sknotnull") \
                .for_year_and_station(station, year) \
                .group("sknotnull") \
                .collect { |i| [i[:sknotnull], i[:count].to_i] }
  end

  def self.stats_by_month(station, year)
    result = Intervention.for_year_and_station(station, year).group('MONTH(start_date)').count
    result = Hash[*(1..12).to_a.zip(Array.new(12, 0)).flatten].merge(result)
    result.sort { |result_a, result_b| result_a[0].to_i <=> result_b[0].to_i }.map{ |month, number| number }
  end

  def self.stats_by_hour(station, year)
    result = Intervention.select("HOUR(CONVERT_TZ(start_date, '+00:00', '#{Time.zone.formatted_offset}')) AS hour, COUNT(interventions.id) AS count") \
                         .for_year_and_station(station, year) \
                         .group('hour') \
                         .collect { |i| [i[:hour], i[:count].to_i] }
    result = Hash[*(0..23).to_a.zip(Array.new(24, 0)).flatten].merge(Hash[result])
    result.sort { |result_a, result_b| result_a[0].to_i <=> result_b[0].to_i }.map{ |hour, number| number }
  end

  def self.stats_by_city(station, year)
    Intervention.select("COUNT(*) AS count, COALESCE(city, '') AS citynotnull") \
                .for_year_and_station(station, year) \
                .group("citynotnull") \
                .collect { |i| [i[:citynotnull], i[:count].to_i] }
  end

  def self.stats_by_vehicle(station, year)
    Intervention.select("vehicles.name, COUNT(interventions.id) AS count") \
                .joins(:vehicles) \
                .for_year_and_station(station, year) \
                .group("vehicles.name")
                .collect { |i| [i[:name], i[:count].to_i] }
  end

  def self.stats_map(station, year)
    Intervention.for_year_and_station(station, year)
  end

  def self.years_stats(station)
    result = Intervention.select("DISTINCT(YEAR(start_date)) AS year") \
                         .where(:station_id => station.id)
                         .order('year DESC')
    result.collect { |intervention| intervention.year }
  end

  def editable?
    (self.station.intervention_editable_at.blank?) or
    (self.start_date > self.station.intervention_editable_at)
  end

  def self.cities(station)
    result = Intervention.select("DISTINCT(city) AS city") \
                         .where(["interventions.city IS NOT NULL AND interventions.station_id = ?", station.id]) \
                         .order('city')
    result.collect { |intervention| intervention.city }
  end

  def self.subkinds(station)
    result = Intervention.select("DISTINCT(subkind) AS subkind") \
                         .where(["COALESCE(interventions.subkind, '') <> '' AND interventions.station_id = ?", station.id]) \
                         .order('subkind')

    result.collect { |intervention| intervention.subkind }
  end

  def self.stats(station, type, year)
    data = Intervention.send("stats_#{type}", station, year)

    if ["by_type", "by_subkind", "by_city", "by_vehicle"].include?(type)
      sum = data.inject(0) { |sum, stat| sum ? sum+stat[1] : stat[1] }
    elsif ["by_month", "by_hour"].include?(type)
      sum = data.sum
    elsif type == "map"
      sum = data.length
    end
    [data, sum]
  end

  private

  def self.get_last_intervention_number(station)
    result = Intervention.select("COALESCE(MAX(CAST(number AS SIGNED)),0) AS max_number") \
                         .where(:station_id => station.id) \
                         .first
    result[:max_number].to_i
  end

  def self.get_last_intervention_number_this_year(station)
    result = Intervention.select("COALESCE(MAX(CAST(number AS SIGNED)),0) AS max_number") \
                           .where(:station_id => station.id) \
                           .where("YEAR(interventions.start_date) = ?", Date.today.year) \
                           .first
    result[:max_number].to_i
  end

  def init_number
    if self.station.interventions_number_per_year?
      last_intervention_number = Intervention.get_last_intervention_number_this_year(self.station)
    else
      last_intervention_number = Intervention.get_last_intervention_number(self.station)
    end
    ("%0"+self.station.interventions_number_size.to_s+"d") % (last_intervention_number + 1)
  end

  def full_address
    [place, city].compact.join(', ')
  end
end
