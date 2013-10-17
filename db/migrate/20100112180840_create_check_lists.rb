# -*- encoding : utf-8 -*-
class CreateCheckLists < ActiveRecord::Migration
  def self.up
    create_table :check_lists do |t|
      t.string(:title)
      t.references(:station)
      t.timestamps
    end
  end

  def self.down
    drop_table :check_lists
  end
end
