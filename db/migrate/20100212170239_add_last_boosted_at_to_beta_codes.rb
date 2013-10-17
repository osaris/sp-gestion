# -*- encoding : utf-8 -*-
class AddLastBoostedAtToBetaCodes < ActiveRecord::Migration
  def self.up
    add_column(:beta_codes, :last_boosted_at, :datetime)
  end

  def self.down
    add_column(:beta_codes, :last_boosted_at)
  end
end
