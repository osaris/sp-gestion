class Station < ActiveRecord::Base
  
  authenticates_many :user_sessions
  has_many :users
  has_many :convocations
  has_many :firemen
  has_many :uniforms  
  has_many :vehicles
  
  RESERVED_URL =  %w(www blog api ftp sp-gestion spgestion).freeze
  
  validates_presence_of   :url, :message => "L'adresse de votre site est obligatoire."
  validates_presence_of   :name, :message => "Le nom du centre est obligatoire."
  validates_uniqueness_of :url, :message => "Cette adresse est déjà utilisée, veuillez en choisir une autre."
  validates_uniqueness_of :name, :message => "Ce nom de centre est déjà utilisé, veuillez en choisir un autre."
  validates_length_of     :url, :minimum => 5, :message => "L'adresse de votre site doit avoir au minimum 5 caractères."
  validates_length_of     :name, :minimum => 5, :message => "Le nom du centre doit avoir au minimum 5 caractères."
  validates_exclusion_of  :url, :in => RESERVED_URL, :message => "Cette adresse est déjà utilisée, veuillez en choisir une autre."
  validates_format_of     :url, :with => /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*$/ix, :message => "L'adresse ne doit contenir que des chiffres, des lettres et des tirets."
  
end
