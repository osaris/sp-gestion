# Relation table for fireman present in intervention
class FiremanIntervention < ActiveRecord::Base
  
  belongs_to :fireman
  belongs_to :intervention
  
  named_scope :newer, { :include => [:intervention], :order => 'interventions.start_date DESC', :limit => 5}
  
  def before_create
    self.grade = self.fireman.grade
  end
  
end
