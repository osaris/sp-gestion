class Station < ActiveRecord::Base
  
  authenticates_many :user_sessions
  has_many :users, :dependent => :destroy
  has_many :convocations, :dependent => :destroy
  has_many :check_lists, :dependent => :destroy
  has_many :firemen, :dependent => :destroy
  has_many :interventions, :dependent => :destroy
  has_many :uniforms, :dependent => :destroy
  has_many :vehicles, :dependent => :destroy
  
  RESERVED_URL =  %w(sp-gestion spgestion).freeze
  
  validates_presence_of   :url, :message => "L'adresse de votre site est obligatoire."
  validates_presence_of   :name, :message => "Le nom du centre est obligatoire."
  validates_uniqueness_of :url, :message => "Cette adresse est déjà utilisée, veuillez en choisir une autre."
  validates_uniqueness_of :name, :message => "Ce nom de centre est déjà utilisé, veuillez en choisir un autre."
  validates_length_of     :url, :minimum => 5, :message => "L'adresse de votre site doit avoir au minimum 5 caractères."
  validates_length_of     :name, :minimum => 5, :message => "Le nom du centre doit avoir au minimum 5 caractères."
  validates_exclusion_of  :url, :in => RESERVED_URL, :message => "Cette adresse est déjà utilisée, veuillez en choisir une autre."
  validates_format_of     :url, :with => /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*$/ix, :message => "L'adresse ne doit contenir que des chiffres, des lettres et des tirets."

  after_create :create_defaults_uniforms
  
  def self.check(q)
    station = nil
    unless q.blank?
      search = "%#{q}%"
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
  
  private
  
  def create_defaults_uniforms
    Uniform.create_defaults(self)
  end

end
