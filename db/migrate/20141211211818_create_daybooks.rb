class CreateDaybooks < ActiveRecord::Migration
  def change
    create_table :daybooks do |t|
      t.string(:text)
      t.boolean(:frontpage)
      t.references(:station)
      t.timestamps
    end
  end
end
