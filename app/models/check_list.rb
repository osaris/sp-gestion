class CheckList < ActiveRecord::Base

  belongs_to :station
  has_many :items, :dependent => :destroy

  validates_presence_of :title, :message => "Le titre est obligatoire."
  
end
