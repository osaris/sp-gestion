class AddFiremanAvailabilities < ActiveRecord::Migration
  def change
    create_table "fireman_availabilities" do |t|
      t.references :fireman
      t.references :station
      t.datetime :availability
      t.timestamps
    end
  end
end
