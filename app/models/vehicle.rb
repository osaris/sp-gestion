class Vehicle < ActiveRecord::Base

  belongs_to :station
  has_many :intervention_vehicles
  has_many :interventions, :through => :intervention_vehicles

  mount_uploader :vehicle_photo, VehiclePhotoUploader

  validates_presence_of :name, :message => "Le nom est obligatoire."
  validates_date :date_approval, :allow_blank => true
  validates_date :date_check, :allow_blank => true
  validates_date :date_review, :allow_blank => true
  validates_date :date_delisting, :allow_blank => true
  validates_with VehicleValidator

  attr_accessor :validate_date_delisting_update
  attr_reader :warnings

  before_save :warn_if_date_delisting_changed
  after_save :update_intervention_editable_at
  before_destroy :check_associations

  scope :not_delisted, -> { where("COALESCE(vehicles.date_delisting, '') = ''") }
  scope :delisted, -> { where("COALESCE(vehicles.date_delisting, '') <> ''") }

  private

  def update_intervention_editable_at
    self.station.update_intervention_editable_at if self.date_delisting_changed?
  end

  def check_associations
    unless self.interventions.empty?
      self.errors[:base] << "Impossible de supprimer ce véhicule car il a \
      effectué des interventions, vous pouvez lui indiquer une date de radiation \
      afin qu'il n'apparaisse plus dans la liste des véhicules pour la saisie des \
      interventions." and return false
    end
  end

  def warn_if_date_delisting_changed
    if self.date_delisting_changed?
      @warnings = "Attention, ce véhicule est désormais dans la liste des véhicules"
      @warnings += self.date_delisting.blank? ? "." : " radiés."
    end
  end
end
