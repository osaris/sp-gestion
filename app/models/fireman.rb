class Fireman < ActiveRecord::Base
  
  validates_presence_of :firstname, :message => "Le prénom est obligatoire."
  validates_presence_of :lastname, :message => "Le nom est obligatoire."
  
end
