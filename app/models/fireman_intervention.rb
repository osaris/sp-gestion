# Relation table for fireman present in intervention
class FiremanIntervention < ActiveRecord::Base

  belongs_to :fireman
  belongs_to :intervention

  scope :newer, { :include => [:intervention], :order => 'interventions.start_date DESC', :limit => 5}

  before_create :set_grade

  protected

  def set_grade
    self.grade = self.fireman.grade
  end

end
