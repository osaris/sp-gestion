class Group < ActiveRecord::Base

  belongs_to :station
  has_many :users
  has_many :permissions, :dependent => :delete_all
  has_many :resources, :through => :permissions

  accepts_nested_attributes_for :permissions, :allow_destroy => true

  validates_presence_of :name, :message => "Le nom est obligatoire."

  def initialized_permissions(resources)
    [].tap do |o|
      resources.each do |resource|
        if p = permissions.find { |p| p.resource_id == resource.id }
          o << p
        else
          o << Permission.new(:resource_id => resource.id)
        end
      end
    end
  end
end
