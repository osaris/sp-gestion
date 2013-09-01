# -*- encoding : utf-8 -*-
class Fireman < ActiveRecord::Base

  attr_accessible :firstname, :lastname, :status, :birthday, :rem, :checkup, :email, :passeport_photo, :remove_passeport_photo, \
                  :regimental_number, :incorporation_date, :resignation_date, :checkup_truck, :tag_list, :grades_attributes, \
                  :validate_grade_update

  belongs_to :station
  has_many :grades, :order => 'kind DESC', :dependent => :destroy
  has_many :convocation_firemen
  has_many :convocations, :through => :convocation_firemen, :order => 'date DESC'
  has_many :fireman_interventions
  has_many :interventions, :through => :fireman_interventions
  has_many :fireman_trainings
  has_many :trainings, :through => :fireman_trainings

  accepts_nested_attributes_for :grades

  mount_uploader :passeport_photo, PasseportPhotoUploader

  validates_presence_of :firstname, :message => "Le prénom est obligatoire."
  validates_presence_of :lastname, :message => "Le nom est obligatoire."
  validates_presence_of :status
  validates_date :birthday, :allow_blank => true, :on_or_before => :today
  validates_date :incorporation_date, :allow_blank => true, :on_or_before => :today
  validates_date :resignation_date, :allow_blank => true, :after => :incorporation_date
  validates_date :checkup, :allow_blank => true
  validates_date :checkup_truck, :allow_blank => true
  validates_format_of :email, :with => Authlogic::Regex.email, :message => "L'adresse email est mal formée.", :allow_blank => true
  validates_length_of :email, :within => 6..100, :message => "L'adresse email doit avoir au minimum 6 caractères.", :allow_blank => true
  validates_with FiremanValidator

  attr_accessor :validate_grade_update
  attr_reader :warnings

  before_save :denormalize_grade
  before_save :warn_if_resignation_date_changed
  before_destroy :check_associations

  acts_as_taggable_on :tags

  STATUS = {
    'JSP' => 1,
    'Vétéran' => 2,
    'Actif' => 3
  }.freeze

  STATUS_PLURAL = {
    'JSP' => 1,
    'Vétérans' => 2,
    'Actifs' => 3
  }

  scope :order_by_grade_and_lastname, order('firemen.grade DESC, firemen.lastname ASC')
  scope :not_resigned, where("COALESCE(firemen.resignation_date, '') = ''")
  scope :resigned, where("COALESCE(firemen.resignation_date, '') <> ''")
  scope :active, where(:status => Fireman::STATUS['Actif'])

  def initialize(params = nil, *args)
    super
    self.status ||= 3
    self.grades = Grade.new_defaults() if self.grades.length != Grade::GRADE.length
    @warnings = ""
  end

  def years_stats
    result = ActiveRecord::Base.connection.select_all(<<-eos % [self.id, self.id])
      SELECT DISTINCT(year) AS year
      FROM
      (
      SELECT DISTINCT(YEAR(interventions.start_date)) AS year
      FROM firemen
      INNER JOIN fireman_interventions ON fireman_interventions.fireman_id = firemen.id
      INNER JOIN interventions ON interventions.id = fireman_interventions.intervention_id
      WHERE firemen.id = %s

      UNION ALL

      SELECT DISTINCT(YEAR(convocations.date)) AS year
      FROM firemen
      INNER JOIN convocation_firemen ON (convocation_firemen.fireman_id = firemen.id)
      INNER JOIN convocations ON (convocations.id = convocation_firemen.convocation_id)
      WHERE firemen.id = %s

      ) VIEW
      ORDER BY year DESC
    eos
    result.each { |line| line.symbolize_keys! }
    result.map { |line| line[:year] }
  end

  def current_grade
    self.grades.each do |grade|
      return grade if (!grade.date.blank?) and (grade.date <= Date.today)
    end
    return nil
  end

  def max_grade_date
    result = self.grades.collect { |grade| grade.date }.compact.max
    result.to_date unless result == nil
  end

  def stats_interventions(station, year)
    nb_interventions = FiremanIntervention.joins(:intervention) \
                                          .where("YEAR(interventions.start_date) = ?", year) \
                                          .where(:fireman_id => self.id) \
                                          .count

    total_interventions = Intervention.where(:station_id => station.id) \
                                      .where("YEAR(interventions.start_date) = ?", year)
                                      .count

    if total_interventions.to_i > 0
      ratio = (nb_interventions.to_i*100) / total_interventions
    else
      ratio = 0
    end

    result = {:nb_interventions => nb_interventions,
              :total_interventions => total_interventions,
              :ratio => ratio }
  end

  def stats_convocations(station, year)
    result = ConvocationFireman.select("COUNT(*) AS total,
                                        COALESCE(SUM(IF(presence = 0,1,0)),0) AS missings,
                                        COALESCE(SUM(IF(presence = 1,1,0)),0) as presents") \
                               .joins(:convocation) \
                               .where("YEAR(convocations.date) = ?", year) \
                               .where(:fireman_id => self.id) \
                               .first

    if result[:total].to_i > 0
      ratio = (result[:presents].to_i*100)/result[:total].to_i
    else
      ratio = 0
    end
    result = {:total => result[:total].to_i,
              :presents => result[:presents].to_i,
              :missings => result[:missings].to_i,
              :ratio => ratio.to_i}
  end

  def self.distinct_tags(station)
    result = Fireman.not_resigned
                    .select("DISTINCT(tags.name) AS name") \
                    .joins("INNER JOIN taggings ON firemen.id = taggings.taggable_id AND taggings.taggable_type = 'Fireman'") \
                    .joins("INNER JOIN tags ON taggings.tag_id = tags.id") \
                    .where(:station_id => station.id) \
                    .order('tags.name')
    result.map! { |tag| tag.name }
  end

  private

  def check_associations
    unless self.convocations.empty?
      self.errors[:base] << "Impossible de supprimer cette personne car elle possède des convocations." and return false
    end
    unless self.interventions.empty?
      self.errors[:base] << "Impossible de supprimer cette personne car elle a effectué des interventions." and return false
    end
    unless self.trainings.empty?
      self.errors[:base] << "Impossible de supprimer cette personne car elle a effectué des formations." and return false
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

  def warn_if_resignation_date_changed
    if self.resignation_date_changed?
      @warnings = "Attention, cette personne est désormais dans la liste des hommes"
      @warnings += self.resignation_date.blank? ? "." : " radiés."
    end
  end

end
