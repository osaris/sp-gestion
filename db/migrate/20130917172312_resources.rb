class Resources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string(:title)
      t.string(:name)
      t.string(:category)
      t.timestamps
    end
  end
end
