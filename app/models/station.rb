# -*- encoding : utf-8 -*-
class Station < ActiveRecord::Base

  # TODO fix when https://github.com/binarylogic/authlogic/issues/135 is closed
  class FindOptions
    def inspect
      '{ :conditions => ["`users`.station_id = ?", id] }'
    end
  end
  authenticates_many :user_sessions, :find_options => FindOptions.new

  has_many :fireman_trainings, :dependent => :destroy
  has_many :convocations, :dependent => :destroy
  has_many :interventions, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :check_lists, :dependent => :destroy
  has_many :fireman_availabilities, :dependent => :destroy
  has_many :firemen, :dependent => :destroy
  has_many :intervention_roles, :dependent => :destroy
  has_many :trainings, -> { order 'short_name' }, :dependent => :destroy
  has_many :uniforms, :dependent => :destroy
  has_many :vehicles, :dependent => :destroy
  has_one  :owner, :class_name => "User"
  has_many :groups, :dependent => :destroy

  mount_uploader :logo, LogoUploader

  RESERVED_URL =  %w(sp-gestion spgestion forum).freeze

  validates_presence_of     :url, :message => "L'adresse de votre site est obligatoire."
  validates_presence_of     :name, :message => "Le nom du centre est obligatoire."
  validates_uniqueness_of   :url, :message => "Cette adresse est déjà utilisée, veuillez en choisir une autre."
  validates_uniqueness_of   :name, :message => "Ce nom de centre est déjà utilisé, veuillez en choisir un autre."
  validates_length_of       :url, :minimum => 5, :message => "L'adresse de votre site doit avoir au minimum 5 caractères."
  validates_length_of       :name, :minimum => 5, :message => "Le nom du centre doit avoir au minimum 5 caractères."
  validates_exclusion_of    :url, :in => RESERVED_URL, :message => "Cette adresse est déjà utilisée, veuillez en choisir une autre."
  validates_format_of       :url, :with => /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*/ix, :message => "L'adresse ne doit contenir que des chiffres, des lettres et des tirets."
  validates_numericality_of :interventions_number_size, :greater_than_or_equal_to => 0, :less_than => 11, :message => "La longueur doit être entre 0 et 10."

  after_create :create_defaults_uniforms
  after_create :set_owner

  scope :demo, -> { where(:demo => true) }

  def initialize(params = nil, *args)
    super
    self.last_email_sent_at ||= Time.now - 2.hours
    self.interventions_number_per_year ||= false
    self.interventions_number_size ||= 0
    self.demo ||= false
  end

  def self.check(query)
    station = nil
    unless query.blank?
      search = "%#{query}%"
      station = Station.where(["(url LIKE ?) OR (name LIKE ?)", search, search]).first
    end
    station
  end

  def update_intervention_editable_at
    max_grade_date = Grade.joins(:fireman).where(["firemen.station_id = ?", self.id]).maximum(:date)
    max_vehicle_delisting_date = self.vehicles.maximum(:date_delisting)
    self.update_attribute(:intervention_editable_at, [max_grade_date, max_vehicle_delisting_date].compact.max)
  end

  def confirm_intervention_editable_at?(new_date)
    (!intervention_editable_at.blank?) and
    (!interventions.empty?) and
    (new_date > intervention_editable_at)
  end

  def update_owner(new_owner_id)
    self.users.confirmed.where(["users.id != ?", self.owner_id]).find(new_owner_id)
    return update_attribute(:owner_id, new_owner_id)
   rescue ActiveRecord::RecordNotFound
    return false
  end

  def can_send_email?(number)
    reset_email_limitation
    (self.nb_email_sent+number <= NB_EMAIL_PER_HOUR)
  end

  def reset_email_limitation
    update_attribute(:nb_email_sent, 0) if self.last_email_sent_at < 1.hour.ago
  end

  private

  def create_defaults_uniforms
    Uniform.delay.create_defaults(self)
  end

  def set_owner
    update_attribute(:owner_id, self.users.first.id) unless self.users.first.blank? # for test purpose only :-/
  end

end
