class Uniform < ActiveRecord::Base
  
  belongs_to :station
  has_many :convocations
  
  validates_presence_of :title, :message => "Le titre est obligatoire."
  validates_presence_of :description, :message => "La description est obligatoire."
  
  before_destroy :check_associations
  
  private
  
  def check_associations
    unless self.convocations.size == 0
      self.errors.add_to_base("Impossible de supprimer cette tenue car elle est utilisée par une ou plusieurs convocations.") and return false
    end
  end
  
end
