class Item < ActiveRecord::Base

  belongs_to :check_list

  mount_uploader :item_photo, ItemPhotoUploader

  validates_presence_of :title, :message => "Le titre est obligatoire."
  validates_numericality_of :quantity, :message => "La quantité doit être un nombre."
  validates_date :expiry, :allow_blank => true

  scope :expirings, lambda { |nb_days, station_id|
      includes(:check_list) \
      .where(['items.expiry < ? AND check_lists.station_id = ?', nb_days.days.from_now, station_id]) \
      .references(:check_list) \
      .order('items.expiry ASC')
  }

end
