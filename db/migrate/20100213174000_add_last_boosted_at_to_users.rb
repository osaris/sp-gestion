# -*- encoding : utf-8 -*-
class AddLastBoostedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column(:users, :last_boosted_at, :datetime)
  end

  def self.down
    add_column(:users, :last_boosted_at)
  end
end
