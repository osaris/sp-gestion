class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references(:station)
      t.string(:name)

      t.timestamps
    end
  end
end
