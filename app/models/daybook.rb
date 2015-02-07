class Daybook < ActiveRecord::Base

  belongs_to :station

  validates_presence_of :text, :message => "Le texte est obligatoire."

  scope :frontpage, -> { where(:frontpage => true) }

  def initialize(params = nil, *args)
    super
    self.frontpage ||= true
  end
end
