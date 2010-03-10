class Intervention < ActiveRecord::Base
  
  belongs_to :station
  has_many :intervention_vehicles
  has_many :vehicles, :through => :intervention_vehicles
  has_many :fireman_interventions, :order => 'fireman_interventions.grade DESC'
  has_many :firemen, :through => :fireman_interventions
  
  validates_presence_of :place, :message => "Le lieu est obligatoire"
  validates_presence_of :kind
  # FIXME record is saved even if this validation failed, it's a Rails bug
  # https://rails.lighthouseapp.com/projects/8994/tickets/922-has_many-through-transaction-rollback
  validates_presence_of :firemen, :message => "Le personnel est obligatoire."  
  validates_datetime :start_date, :invalid_datetime_message => "Format incorrect (JJ/MM/AAAA HH:MM)"
  validates_datetime :end_date, :invalid_datetime_message => "Format incorrect (JJ/MM/AAAA HH:MM)"
  
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
  
  def self.stats_by_type(station)
    count(:all, :group => 'kind', :conditions => {:station_id => station.id})
  end
  
  private
  
  def init_number
    self.number = self.station.interventions.size + 1
  end
  
end
