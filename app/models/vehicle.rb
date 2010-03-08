class Vehicle < ActiveRecord::Base
  
  belongs_to :station
  has_and_belongs_to_many :interventions
  
  validates_presence_of :name, :message => "Le nom est obligatoire."
    
end
