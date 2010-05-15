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
  validates_datetime :start_date, :invalid_datetime_message => "Format incorrect (JJ/MM/AAAA HH:MM)"
  validates_datetime :end_date, :invalid_datetime_message => "Format incorrect (JJ/MM/AAAA HH:MM)"

  acts_as_geocodable :address => {:street => :place, :locality => :city}

  before_create :init_number

  KIND = {
    :sap => 1,
    :inc => 2,
    :div => 3,
    :sr => 4
  }.freeze

  named_scope :newer, { :order => 'start_date DESC' }

  named_scope :limit, lambda { |num|
    {:limit => num }
  }

  def initialize(params = nil)
    super
    self.kind ||= KIND[:sap]
  end

  def validate
    if (!end_date.blank? and !start_date.blank? )
      self.errors.add(:end_date, "Ne peut pas être avant la date de début !") if end_date < start_date
      self.errors.add(:start_date, "Ne peut pas être dans le futur !") if start_date > Time.now
      self.errors.add(:end_date, "Ne peut pas être dans le futur !") if end_date > Time.now
    end
  end

  def self.stats_by_type(station, year)
    count(:all, :group => 'kind', :conditions => ["station_id = ? AND YEAR(start_date) = ?", station.id, year])
  end

  def self.stats_by_month(station, year)
    result = count(:all, :group => 'MONTH(start_date)', :conditions => ["station_id = ? AND YEAR(start_date) = ?", station.id, year])
    result = Hash["1",0,"2",0,"3",0,"4",0,"5",0,"6",0,"7",0,"8",0,"9",0,"10",0,"11",0,"12",0].merge(result)
    result.sort { |result_a, result_b| result_a[0].to_i <=> result_b[0].to_i }.map{ |month, number| number }
  end

  def self.min_max_year(station)
    result = ActiveRecord::Base.connection.select_one("SELECT MIN(YEAR(start_date)) AS min_year,
                                                      MAX(YEAR(end_date)) AS max_year
                                                      FROM interventions
                                                      WHERE interventions.station_id = #{station.id}")
    [result["min_year"], result["max_year"]]
  end

  def editable?
    (self.station.last_grade_update_at.blank?) or (self.start_date > self.station.last_grade_update_at)
  end

  def self.cities(station)
    ActiveRecord::Base.connection.select_values("SELECT DISTINCT city
                                                 FROM interventions
                                                 WHERE interventions.city IS NOT NULL
                                                 AND interventions.station_id = #{station.id}
                                                 ORDER BY city")
  end

  private

  def init_number
    self.number = self.station.interventions.size + 1
  end
end
