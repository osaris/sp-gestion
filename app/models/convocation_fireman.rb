# Relation table for fireman presence at convocation
class ConvocationFireman < ActiveRecord::Base

  belongs_to :convocation
  belongs_to :fireman

  named_scope :newer, { :include => [:convocation], :order => 'convocations.date DESC', :limit => 5}
  named_scope :with_email, { :include => [:fireman], :conditions => ['firemen.email IS NOT NULL'] }

  def before_create
    self.grade = self.fireman.grade
    self.status = self.fireman.status
  end

end
