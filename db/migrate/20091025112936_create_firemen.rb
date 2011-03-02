# -*- encoding : utf-8 -*-
class CreateFiremen < ActiveRecord::Migration
  def self.up
    create_table :firemen do |t|
      t.string :firstname
      t.string :lastname
      t.references :station
      t.timestamps
    end
  end

  def self.down
    drop_table :firemen
  end
end
