# All items belongs to the station
class Station < ActiveRecord::Base

  authenticates_many :user_sessions
  has_many :users, :dependent => :destroy
  has_many :convocations, :dependent => :destroy
  has_many :check_lists, :dependent => :destroy
  has_many :firemen, :dependent => :destroy
  has_many :interventions, :dependent => :destroy
  has_many :uniforms, :dependent => :destroy
  has_many :vehicles, :dependent => :destroy
  has_one  :owner, :class_name => "User"

  RESERVED_URL =  %w(sp-gestion spgestion blog).freeze

  validates_presence_of   :url, :message => "L'adresse de votre site est obligatoire."
  validates_presence_of   :name, :message => "Le nom du centre est obligatoire."
  validates_uniqueness_of :url, :message => "Cette adresse est déjà utilisée, veuillez en choisir une autre."
  validates_uniqueness_of :name, :message => "Ce nom de centre est déjà utilisé, veuillez en choisir un autre."
  validates_length_of     :url, :minimum => 5, :message => "L'adresse de votre site doit avoir au minimum 5 caractères."
  validates_length_of     :name, :minimum => 5, :message => "Le nom du centre doit avoir au minimum 5 caractères."
  validates_exclusion_of  :url, :in => RESERVED_URL, :message => "Cette adresse est déjà utilisée, veuillez en choisir une autre."
  validates_format_of     :url, :with => /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*$/ix, :message => "L'adresse ne doit contenir que des chiffres, des lettres et des tirets."

  after_create :create_defaults_uniforms
  after_create :set_owner

  def initialize(params = nil)
    super
    self.last_email_sent_at ||= Time.now - 2.hours
  end

  def self.check(query)
    station = nil
    unless query.blank?
      search = "%#{query}%"
      station = self.find(:first, :conditions => ["(url LIKE ?) OR (name LIKE ?)", search, search])
    end
    station
  end

  def reset_last_grade_update_at
    max_grade_date = Grade.maximum(:date,
                                   :joins => "INNER JOIN firemen ON (firemen.id = grades.fireman_id)",
                                   :conditions => ["firemen.station_id = ?", self.id])
    self.update_attribute(:last_grade_update_at, max_grade_date)
  end

  def confirm_last_grade_update_at?(max_grade_date)
    result = true
    if self.last_grade_update_at.blank?
      result = false
    elsif self.interventions.empty?
      result = false
    elsif max_grade_date <= self.last_grade_update_at
      result = false
    end
    result
  end

  def update_owner(new_owner_id)
    self.users.confirmed.find(new_owner_id, :conditions => ["users.id != ?", self.owner_id])
    return update_attribute(:owner_id, new_owner_id)
   rescue ActiveRecord::RecordNotFound
    return false
  end

  def can_send_email?(number)
    reset_email_limitation
    (self.nb_email_sent+number <= NB_EMAIL_PER_HOUR)
  end

  private

  def reset_email_limitation
    update_attribute(:nb_email_sent, 0) if self.last_email_sent_at < 1.hour.ago
  end

  def create_defaults_uniforms
    Uniform.send_later(:create_defaults, self)
  end

  def set_owner
    update_attribute(:owner_id, self.users.first.id) unless self.users.first.blank? # for test purpose only :-/
  end

end
