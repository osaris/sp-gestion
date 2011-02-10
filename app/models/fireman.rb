# The guy
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
  validates_format_of :email, :with => Authlogic::Regex.email, :message => "L'adresse email est mal formée.", :allow_blank => true
  validates_length_of :email, :within => 6..100, :message => "L'adresse email doit avoir au minimum 6 caractères.", :allow_blank => true
  validates_with FiremanValidator

  attr_accessor :validate_grade_update

  before_save :denormalize_grade
  before_destroy :check_associations

  acts_as_taggable_on :tags

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
    self.grades.each do |grade|
      return grade if (!grade.date.blank?) and (grade.date <= Date.today)
    end
    return nil
  end

  def self.per_page
    20
  end

  def max_grade_date
    result = self.grades.collect { |grade| grade.date }.compact.max
    result.to_date unless result == nil
  end

  def stats_interventions
    FiremanIntervention.where(:fireman_id => self.id).count
  end

  def stats_convocations
    ConvocationFireman.select("COUNT(*) AS total, COALESCE(SUM(IF(presence = 0,1,0)),0) AS missings, COALESCE(SUM(IF(presence = 1,1,0)),0) as presents") \
                      .where(:fireman_id => self.id) \
                      .first
  end

  def self.distinct_tags(station)
    result = Fireman.select("DISTINCT(tags.name) AS name") \
                    .joins("INNER JOIN taggings ON firemen.id = taggings.taggable_id AND taggings.taggable_type = 'Fireman'") \
                    .joins("INNER JOIN tags ON taggings.tag_id = tags.id") \
                    .where(:station_id => station.id) \
                    .order('tags.name')
    result.map! { |tag| [tag.name, tag.name, tag.name] }
  end

  private

  def check_associations
    unless self.convocations.empty?
      self.errors[:base] << "Impossible de supprimer cette personne car elle possède des convocations." and return false
    end
    unless self.interventions.empty?
      self.errors[:base] << "Impossible de supprimer cette personne car elle a effectué des interventions." and return false
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