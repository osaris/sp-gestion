# -*- encoding : utf-8 -*-
class Uniform < ActiveRecord::Base

  belongs_to :station
  has_many :convocations

  validates_presence_of :title, :message => "Le titre est obligatoire."
  validates_presence_of :description, :message => "La description est obligatoire."

  before_destroy :check_associations

  DEFAULTS = [
    {:title => "Tenue SAP", :description => "Bottes/rangers. Pantalon F1. T-Shirt/polo. (Pull/sweat/veste F1/parka)"},
    {:title => "Tenue INC", :description => "Bottes/rangers. Pantalon F1. Surpantalon. Chemise F1. Veste de Feu. Ceinturon (avec gants). Casque F1."},
    {:title => "Tenue SR/DIV", :description => "Bottes/rangers. Pantalon F1. Chemise F1. Veste de Feu. Ceinturon (avec gants). Casque F1 ou F2."},
    {:title => "Tenue FdF", :description => "Bottes/rangers. Pantalon F2. Chemise F1. Veste de Feu F2. Ceinturon (avec gants). Casque F2."},
    {:title => "Tenue cérémonie", :description => "Chaussures. Pantalon. Chemise. Gants blancs, képi. (Vareuse)"}
  ]

  def self.create_defaults(station)
    DEFAULTS.each do |uniform|
      self.create(uniform.merge(:station => station))
    end
  end

  private

  def check_associations
    unless self.convocations.empty?
      self.errors[:base] << "Impossible de supprimer cette tenue car elle est utilisée par une ou plusieurs convocations." and return false
    end
  end

end
