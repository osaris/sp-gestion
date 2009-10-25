class Vehicle < ActiveRecord::Base
  
  validates_presence_of :name, :message => "Le nom est obligatoire."
  
end
