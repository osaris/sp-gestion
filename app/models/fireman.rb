class Fireman < ActiveRecord::Base
  
  belongs_to :station

  validates_presence_of :firstname, :message => "Le prénom est obligatoire."
  validates_presence_of :lastname, :message => "Le nom est obligatoire."
  
  def self.per_page
    20
  end
  
end