class Uniform < ActiveRecord::Base
  
  belongs_to :station
  has_many :convocations
  
  validates_presence_of :title, :message => "Le titre est obligatoire."
  validates_presence_of :description, :message => "La description est obligatoire."
  
  before_destroy :check_associations
  
  DEFAULTS = [
    {:title => "Tenue d'intervention", :description => "Casquette, veste F1, pantalon F1, rangers ou bottes."},
    {:title => "Tenue de feu", :description => "Casque F1, cagoule, veste de feu, gants, ceinturons, surpantalon, rangers ou bottes."},
    {:title => "Tenue de cérémonie", :description => "Casque F1, veste F1, pantalon F1, rangers ou bottes."}
  ]
  
  def self.create_defaults(station)
    DEFAULTS.each do |uniform|
      self.create(uniform.merge(:station => station))
    end
  end
  
  private
  
  def check_associations
    unless self.convocations.empty?
      self.errors.add_to_base("Impossible de supprimer cette tenue car elle est utilisée par une ou plusieurs convocations.") and return false
    end
  end
  
end
