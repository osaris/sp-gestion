# -*- encoding : utf-8 -*-
class CheckList < ActiveRecord::Base

  attr_accessible :title

  belongs_to :station
  has_many :items, :dependent => :destroy

  validates_presence_of :title, :message => "Le titre est obligatoire."

  def copy
    copy = self.dup
    self.items.each do |item|
      copy.items << item.dup
    end
    copy.title = "Copie de " + self.title
    copy.save
    copy
  end

  def places
    result = Item.select("DISTINCT(place) AS place") \
                 .where(["items.place IS NOT NULL AND items.check_list_id = ?", self.id]) \
                 .order('place')
    result.collect { |item| item.place }
  end
end
