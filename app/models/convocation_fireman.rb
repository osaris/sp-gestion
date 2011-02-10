# Relation table for fireman presence at convocation
class ConvocationFireman < ActiveRecord::Base

  belongs_to :convocation
  belongs_to :fireman

  scope :newer, { :include => [:convocation], :order => 'convocations.date DESC', :limit => 5}
  scope :with_email, { :include => [:fireman], :conditions => ["COALESCE(firemen.email, '') <> ''"] }

  before_create :set_grade_and_status

  protected

  def set_grade_and_status
    self.grade = self.fireman.grade
    self.status = self.fireman.status
  end

end
