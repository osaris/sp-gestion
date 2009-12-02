class Uniform < ActiveRecord::Base
  
  belongs_to :station
  has_many :convocations
  
  validates_presence_of :title, :message => "Le titre est obligatoire."
  validates_presence_of :description, :message => "La description est obligatoire."
  
end
