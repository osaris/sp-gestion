class Fireman < ActiveRecord::Base
  
  belongs_to :station
  has_many :grades, :order => 'kind DESC', :dependent => :destroy
  has_many :convocation_firemen
  has_many :convocations, :through => :convocation_firemen, :order => 'date DESC'
  
  accepts_nested_attributes_for :grades
  
  validates_presence_of :firstname, :message => "Le prénom est obligatoire."
  validates_presence_of :lastname, :message => "Le nom est obligatoire."
  validates_presence_of :status
  validates_date :birthday, :allow_blank => true, :invalid_date_message => "Format incorrect (JJ/MM/AAAA)"
  
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
    if self.status != STATUS['JSP'] and self.grades.reject{ |g| g.date.blank? }.length == 0
      self.errors.add(:grades, "Un membre actif ou vétéran doit avoir un grade.")
    end
  end
  
  private
  
  def check_associations
    unless self.convocations.size == 0
      self.errors.add_to_base("Impossible de supprimer ce membre car il possède des convocations.") and return false
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