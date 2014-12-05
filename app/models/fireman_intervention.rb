class FiremanIntervention < ActiveRecord::Base

  attr_accessor :enable

  belongs_to :fireman
  belongs_to :intervention
  belongs_to :intervention_role

  delegate :place, :city, :number, :start_date, :to => :intervention, :prefix => true
  delegate :firstname, :lastname, :to => :fireman, :prefix => true
  delegate :short_name, :to => :intervention_role, :prefix => true

  scope :newer, -> { order('interventions.start_date DESC').includes(:intervention).limit(5) }

  before_create :set_grade

  protected

  def set_grade
    self.grade = self.fireman.grade
  end

end
