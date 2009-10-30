class Vehicle < ActiveRecord::Base
  
  belongs_to :station
  
  validates_presence_of :name, :message => "Le nom est obligatoire."
  
end
