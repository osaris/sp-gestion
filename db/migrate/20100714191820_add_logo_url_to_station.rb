# -*- encoding : utf-8 -*-
class AddLogoUrlToStation < ActiveRecord::Migration
  def self.up
    add_column(:stations, :logo, :string)
  end

  def self.down
    remove_column(:stations, :logo)
  end
end
