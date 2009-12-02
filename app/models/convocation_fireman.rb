class ConvocationFireman < ActiveRecord::Base
  
  belongs_to :convocation
  belongs_to :fireman
  
  def before_create
    self.grade = self.fireman.grade
    self.status = self.fireman.status
  end
  
end
