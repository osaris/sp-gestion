class DropLastBoostedAtFromUsers < ActiveRecord::Migration
  def change
    remove_column(:users, :last_boosted_at)
  end
end
