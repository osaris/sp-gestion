class AddFiremanIdToUsers < ActiveRecord::Migration
  def change
    add_column(:users, :fireman_id, :integer)
  end
end
