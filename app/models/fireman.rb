class Fireman < ActiveRecord::Base
  
  belongs_to :station
  has_many :grades, :order => 'kind DESC', :dependent => :destroy
  has_many :convocation_firemen
  has_many :convocations, :through => :convocation_firemen, :order => 'date DESC'
  has_many :fireman_interventions
  has_many :interventions, :through => :fireman_interventions
  
  accepts_nested_attributes_for :grades
  
  validates_presence_of :firstname, :message => "Le prénom est obligatoire."
  validates_presence_of :lastname, :message => "Le nom est obligatoire."
  validates_presence_of :status
  validates_date :birthday, :allow_blank => true, :invalid_date_message => "Format incorrect (JJ/MM/AAAA)"
  
  attr_accessor :validate_grade_update
  
  before_save :denormalize_grade
  before_destroy :check_associations
  
  STATUS = {
    'JSP' => 1,
    'Vétéran' => 2,
    'Actif' => 3
  }.freeze

  def initialize(params = nil)
    super
    self.status ||= 3
    self.grades = Grade.new_defaults() if self.grades.length != Grade::GRADE.length
    self.chief ||= false
    self.chief_assistant ||= false
    self.quartermaster ||= false
  end
  
  def current_grade
    self.grades.each do |g|
      return g if (!g.date.blank?) and (g.date <= Date.today)
    end
    return nil
  end
    
  def self.per_page
    20
  end
  
  def validate
    if self.status != STATUS['JSP'] 
      if self.grades.reject{ |g| g.date.blank? }.empty?
        self.errors.add(:grades, "Une personne ayant le statut actif ou vétéran doit avoir un grade.")
      elsif self.station.confirm_last_grade_update_at?(max_grade_date) and (self.validate_grade_update.to_i != 1)
        self.errors.add(:validate_grade_update)
      end
    end
  end
  
  def max_grade_date
    self.grades.collect { |g| g.date }.compact.max
  end
  
  def stats_interventions
    result = ActiveRecord::Base.connection.select_one("SELECT COUNT(*) AS total FROM fireman_interventions WHERE fireman_id = #{self.id}")
    result.symbolize_keys!
  end
  
  def stats_convocations
    result = ActiveRecord::Base.connection.select_one("SELECT 
                                                       COUNT(*) AS total,
                                                       COALESCE(SUM(IF(presence = 0,1,0)),0) AS missing, 
                                                       COALESCE(SUM(IF(presence=1,1,0)),0) as present
                                                       FROM convocation_firemen 
                                                       WHERE fireman_id = #{self.id}")
    result.symbolize_keys!
  end
  
  private
  
  def check_associations
    unless self.convocations.empty?
      self.errors.add_to_base("Impossible de supprimer cette personne car elle possède des convocations.") and return false
    end
    unless self.interventions.empty?
      self.errors.add_to_base("Impossible de supprimer cette personne car elle a effectué des interventions.") and return false
    end
  end
  
  def denormalize_grade
    if self.status == STATUS['JSP']
      self.grade = nil
      self.grade_category = nil
    else
      self.grade = current_grade.nil? ? nil : current_grade.kind
      self.grade_category = Grade::GRADE_CATEGORY_MATCH[self.grade]
    end
  end
  
end