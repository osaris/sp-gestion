# Check list of items
class CheckList < ActiveRecord::Base

  belongs_to :station
  has_many :items, :dependent => :destroy

  validates_presence_of :title, :message => "Le titre est obligatoire."

  def copy
    copy = self.clone
    self.items.each do |item|
      copy.items << item.clone
    end
    copy.title = "Copie de " + self.title
    copy.save
    copy
  end

  def places
    ActiveRecord::Base.connection.select_values("SELECT DISTINCT place
                                                           FROM items
                                                           WHERE items.place IS NOT NULL
                                                           AND items.check_list_id = #{self.id}
                                                           ORDER BY place")
  end

end
